import { useState, useCallback, useEffect, useRef } from 'react';

interface Coordinates {
  lat: number;
  lng: number;
}

interface PlusCode {
  compound_code: string;
  global_code: string;
}

interface StructuredFormatting {
  main_text: string;
  secondary_text: string;
}

interface Prediction {
  description: string;
  matched_substrings: any[];
  place_id: string;
  reference: string;
  structured_formatting: StructuredFormatting;
  terms: any[];
  has_children: boolean;
  display_type: string;
  score: number;
  plus_code: PlusCode;
}

interface AutoCompleteResponse {
  predictions: Prediction[];
  executed_time: number;
  executed_time_all: number;
  status: string;
}

interface PlaceDetailResult {
  place_id: string;
  formatted_address: string;
  geometry: {
    location: Coordinates;
  };
  name: string;
}

interface PlaceDetailResponse {
  result: PlaceDetailResult;
  status: string;
}

interface UseMapOptions {
  apiKey: string;
  defaultLocation?: Coordinates;
  defaultRadius?: number;
  defaultLimit?: number;
  debounceMs?: number;
  onLocationChange?: (location: Coordinates) => void;
  onError?: (error: Error) => void;
}

export function useMap({
  apiKey,
  defaultLocation,
  defaultRadius = 50,
  defaultLimit = 10,
  debounceMs = 500,
  onLocationChange,
  onError,
}: UseMapOptions) {
  const [searchTerm, setSearchTerm] = useState<string>('');
  const [predictions, setPredictions] = useState<Prediction[]>([]);
  const [selectedPlace, setSelectedPlace] = useState<PlaceDetailResult | null>(null);
  const [currentLocation, setCurrentLocation] = useState<Coordinates | undefined>(defaultLocation);
  const [radius, setRadius] = useState<number>(defaultRadius);
  const [limit, setLimit] = useState<number>(defaultLimit);
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<Error | null>(null);
  
  // Debounce timer ref
  const debounceTimerRef = useRef<NodeJS.Timeout | null>(null);
  
  // Generate a session token (UUID v4)
  const [sessionToken] = useState<string>(() => {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      const r = Math.random() * 16 | 0;
      const v = c === 'x' ? r : (r & 0x3 | 0x8);
      return v.toString(16);
    });
  });

  // Debounce function
  const debounce = useCallback((fn: Function, delay: number) => {
    if (debounceTimerRef.current) {
      clearTimeout(debounceTimerRef.current);
    }
    
    debounceTimerRef.current = setTimeout(() => {
      fn();
      debounceTimerRef.current = null;
    }, delay);
  }, []);

  // Search places with autocomplete
  const searchPlaces = useCallback(async (input: string, moreCompound = false) => {
    if (!input.trim()) {
      setPredictions([]);
      return;
    }
    
    try {
      setLoading(true);
      setError(null);
      
      const locationParam = currentLocation 
        ? `&location=${currentLocation.lat},${currentLocation.lng}` 
        : '';
      
      const url = `https://rsapi.goong.io/Place/AutoComplete?api_key=${apiKey}` +
        `&input=${encodeURIComponent(input)}` +
        `${locationParam}` +
        `&limit=${limit}` +
        `&radius=${radius}` +
        `&sessiontoken=${sessionToken}` +
        `&more_compound=${moreCompound}`;
      
      const response = await fetch(url);
      
      if (!response.ok) {
        throw new Error(`API error: ${response.status}`);
      }
      
      const data = await response.json() as AutoCompleteResponse;
      
      if (data.status === 'OK') {
        setPredictions(data.predictions);
      } else {
        setPredictions([]);
        throw new Error(`API status: ${data.status}`);
      }
    } catch (err) {
      setError(err instanceof Error ? err : new Error('Unknown error occurred'));
      if (onError) onError(err instanceof Error ? err : new Error('Unknown error occurred'));
    } finally {
      setLoading(false);
    }
  }, [apiKey, currentLocation, limit, radius, sessionToken, onError]);

  // Get place details
  const getPlaceDetails = useCallback(async (placeId: string) => {
    try {
      setLoading(true);
      setError(null);
      
      const url = `https://rsapi.goong.io/Place/Detail?api_key=${apiKey}` +
        `&place_id=${encodeURIComponent(placeId)}` +
        `&sessiontoken=${sessionToken}`;
      
      const response = await fetch(url);
      
      if (!response.ok) {
        throw new Error(`API error: ${response.status}`);
      }
      
      const data = await response.json() as PlaceDetailResponse;
      
      if (data.status === 'OK') {
        setSelectedPlace(data.result);
        
        if (data.result.geometry.location && onLocationChange) {
          onLocationChange(data.result.geometry.location);
        }
        
        return data.result;
      } else {
        throw new Error(`API status: ${data.status}`);
      }
    } catch (err) {
      setError(err instanceof Error ? err : new Error('Unknown error occurred'));
      if (onError) onError(err instanceof Error ? err : new Error('Unknown error occurred'));
      return null;
    } finally {
      setLoading(false);
    }
  }, [apiKey, sessionToken, onLocationChange, onError]);

  // Update search term and trigger debounced search
  const updateSearchTerm = useCallback((term: string) => {
    setSearchTerm(term);
  }, []);

  // Select a place from predictions
  const selectPlace = useCallback((placeId: string) => {
    return getPlaceDetails(placeId);
  }, [getPlaceDetails]);

  // Update current location
  const updateLocation = useCallback((location: Coordinates) => {
    setCurrentLocation(location);
    if (onLocationChange) onLocationChange(location);
  }, [onLocationChange]);

  // Update search radius
  const updateRadius = useCallback((newRadius: number) => {
    setRadius(newRadius);
  }, []);

  // Update result limit
  const updateLimit = useCallback((newLimit: number) => {
    setLimit(newLimit);
  }, []);

  // Debounced search effect
  useEffect(() => {
    if (searchTerm) {
      debounce(() => {
        searchPlaces(searchTerm);
      }, debounceMs);
    } else {
      setPredictions([]);
    }
    
    // Clean up debounce timer
    return () => {
      if (debounceTimerRef.current) {
        clearTimeout(debounceTimerRef.current);
      }
    };
  }, [searchTerm, searchPlaces, debounce, debounceMs]);

  return {
    searchTerm,
    predictions,
    selectedPlace,
    currentLocation,
    radius,
    limit,
    loading,
    error,
    updateSearchTerm,
    searchPlaces,
    selectPlace,
    getPlaceDetails,
    updateLocation,
    updateRadius,
    updateLimit,
  };
}

export default useMap;