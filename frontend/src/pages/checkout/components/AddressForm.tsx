import React, { useEffect, useRef } from 'react';
import { Form, Input, Button, Row, Col, Space, Select } from 'antd';
import { ShippingInfoDto } from '../../../../generated';
import mapboxgl from 'mapbox-gl';
import useMap from '../../../hooks/useMap';

interface AddressFormProps {
  initialValues?: ShippingInfoDto;
  onSubmit: (values: ShippingInfoDto) => void;
  onCancel: () => void;
}

const AddressForm: React.FC<AddressFormProps> = ({ 
  initialValues, 
  onSubmit, 
  onCancel 
}) => {
  const [form] = Form.useForm();
  const mapContainer = useRef<HTMLDivElement>(null);
  const mapRef = useRef<mapboxgl.Map | null>(null);
  
  const mapKey = import.meta.env.VITE_GOONG_MAPTILE_KEY;
  const apiKey = import.meta.env.VITE_GOONG_TOKEN_KEY;
  
  const {
    searchTerm,
    predictions,
    updateSearchTerm,
    selectPlace
  } = useMap({
    apiKey,
    defaultLocation: { lat: 21.027763, lng: 105.834160 }, // Hanoi center
    defaultRadius: 50
  });
  
  useEffect(() => {
    if (mapContainer.current && !mapRef.current) {
      mapboxgl.accessToken = import.meta.env.VITE_MAP_BOX_TOKEN
      mapRef.current = new mapboxgl.Map({
        container: mapContainer.current,
        style: `https://tiles.goong.io/assets/goong_satellite.json?api_key=${mapKey}`,
        zoom: 12,
        center: [105.834160, 21.027763] // [lng, lat]
      });
    }
    
    return () => {
      if (mapRef.current) {
        mapRef.current.remove();
        mapRef.current = null;
      }
    };
  }, [mapKey]);

  const handleSubmit = (values: ShippingInfoDto) => {
    onSubmit(values);
  };
  
  const handlePlaceSelect = async (placeId: string) => {
    const place = await selectPlace(placeId);
    if (place) {
      const addressParts = place.formatted_address.split(', ');
      let city = '', district = '', ward = '';
      
      if (addressParts.length >= 3) {
        city = addressParts[addressParts.length - 1]; // Last element is city
        district = addressParts[addressParts.length - 2]; // Second last is district
        ward = addressParts[addressParts.length - 3]; // Third last might be ward
      }
      
      form.setFieldsValue({
        address: place.name,
        city,
        district,
        ward
      });
      
      // Update map position
      if (mapRef.current && place.geometry.location) {
        mapRef.current.flyTo({
          center: [place.geometry.location.lng, place.geometry.location.lat],
          zoom: 15
        });
        
        // Add marker
        new mapboxgl.Marker()
          .setLngLat([place.geometry.location.lng, place.geometry.location.lat])
          .addTo(mapRef.current);
      }
    }
  };

  return (
    <Form
      form={form}
      layout="vertical"
      initialValues={initialValues || {}}
      onFinish={handleSubmit}
    >
      <div ref={mapContainer} style={{ width: '100%', height: '300px', marginBottom: '20px' }} />
      
      <Form.Item
        label="Search Address"
      >
        <Select
          showSearch
          value={searchTerm}
          placeholder="Search for an address to automatically fill..."
          defaultActiveFirstOption={false}
          autoFocus
          showArrow={false}
          filterOption={false}
          onSearch={updateSearchTerm}
          onChange={handlePlaceSelect}
          notFoundContent={null}
          options={predictions.map((prediction) => ({
            value: prediction.place_id,
            label: prediction.description,
          }))}
          style={{ width: '100%' }}
        />
      </Form.Item>
      
      <Row gutter={16}>
        <Col span={12}>
          <Form.Item
            name="name"
            label="Full Name"
            rules={[{ required: true, message: 'Please enter your full name' }]}
          >
            <Input placeholder="Full Name" />
          </Form.Item>
        </Col>
        <Col span={12}>
          <Form.Item
            name="phoneNumber"
            label="Phone Number"
            rules={[
              { required: true, message: 'Please enter your phone number' },
              { pattern: /^[0-9]+$/, message: 'Please enter a valid phone number' }
            ]}
          >
            <Input placeholder="Phone Number" />
          </Form.Item>
        </Col>
      </Row>

      <Form.Item
        name="address"
        label="Address Line"
        rules={[{ required: true, message: 'Please enter your address' }]}
      >
        <Input placeholder="Street address, house number, etc." />
      </Form.Item>

      <Row gutter={16}>
        <Col span={8}>
          <Form.Item
            name="city"
            label="City"
            rules={[{ required: true, message: 'Please enter city' }]}
          >
            <Input placeholder="City" />
          </Form.Item>
        </Col>
        <Col span={8}>
          <Form.Item
            name="district"
            label="District"
            rules={[{ required: true, message: 'Please enter district' }]}
          >
            <Input placeholder="District" />
          </Form.Item>
        </Col>
        <Col span={8}>
          <Form.Item
            name="ward"
            label="Ward"
            rules={[{ required: true, message: 'Please enter ward' }]}
          >
            <Input placeholder="Ward" />
          </Form.Item>
        </Col>
      </Row>

      <div className="flex justify-end mt-4">
        <Space>
          <Button onClick={onCancel}>
            Cancel
          </Button>
          <Button type="primary" htmlType="submit">
            {initialValues ? 'Update Address' : 'Add Address'}
          </Button>
        </Space>
      </div>
    </Form>
  );
};

export default AddressForm;