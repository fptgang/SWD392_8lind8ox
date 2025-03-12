import { createSlice, createAsyncThunk, PayloadAction } from '@reduxjs/toolkit';
import { DefaultApi, SetDto, GetSets200Response } from '../../../../generated';
import { RootState } from '../../index';
import axiosInstance from '../../../config/axios-config';
import { API_URL } from '../../../utils/constants';

// API instance
const api = new DefaultApi({
  baseUrl: API_URL,
  securityWorker: () => axiosInstance
});

// Define the state interface
interface SetState {
  currentSet: SetDto | null;
  sets: SetDto[];
  loading: boolean;
  error: string | null;
  pagination: {
    total: number;
    current: number;
    pageSize: number;
  };
}

// Initial state
const initialState: SetState = {
  currentSet: null,
  sets: [],
  loading: false,
  error: null,
  pagination: {
    total: 0,
    current: 1,
    pageSize: 12
  }
};

// Async thunks for API calls
export const fetchSets = createAsyncThunk(
  'set/fetchSets',
  async ({ current = 1, pageSize = 12, filter, search }: { current?: number; pageSize?: number; filter?: string; search?: string }, { rejectWithValue }) => {
    try {
      const response = await api.getSets({
        pageable: {
          page: current - 1, // API is 0-indexed
          size: pageSize,
          sort: []
        },
        filter,
        search
      });
      return response;
    } catch (error: any) {
      return rejectWithValue(error.message || 'Failed to fetch sets');
    }
  }
);

export const fetchSetById = createAsyncThunk(
  'set/fetchSetById',
  async (setId: number, { rejectWithValue }) => {
    try {
      const response = await api.getSetById({ setId });
      return response;
    } catch (error: any) {
      return rejectWithValue(error.message || 'Failed to fetch set details');
    }
  }
);

// Create the slice
const setSlice = createSlice({
  name: 'set',
  initialState,
  reducers: {
    clearCurrentSet: (state) => {
      state.currentSet = null;
    },
    setLoadingState: (state, action: PayloadAction<boolean>) => {
      state.loading = action.payload;
    },
    setError: (state, action: PayloadAction<string | null>) => {
      state.error = action.payload;
    }
  },
  extraReducers: (builder) => {
    builder
      // Handle fetchSets
      .addCase(fetchSets.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchSets.fulfilled, (state, action: PayloadAction<GetSets200Response>) => {
        state.loading = false;
        state.sets = action.payload.content || [];
        state.pagination.total = action.payload.totalElements || 0;
        // Use 1 as default page number if not provided
        state.pagination.current = 1;
        // Use 12 as default page size if not provided
        state.pagination.pageSize = action.payload.numberOfElements || 12;
      })
      .addCase(fetchSets.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload as string || 'An error occurred';
      })
      
      // Handle fetchSetById
      .addCase(fetchSetById.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchSetById.fulfilled, (state, action) => {
        state.loading = false;
        state.currentSet = action.payload;
      })
      .addCase(fetchSetById.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload as string || 'An error occurred';
      });
  }
});

// Export actions and reducer
export const { clearCurrentSet, setLoadingState, setError } = setSlice.actions;

// Selectors
export const selectSets = (state: RootState) => state.set.sets;
export const selectCurrentSet = (state: RootState) => state.set.currentSet;
export const selectSetLoading = (state: RootState) => state.set.loading;
export const selectSetError = (state: RootState) => state.set.error;
export const selectSetPagination = (state: RootState) => state.set.pagination;

export default setSlice.reducer; 