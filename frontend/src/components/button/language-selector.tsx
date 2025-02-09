import { Dropdown, Menu } from 'antd';
import React from 'react';
import i18n from '../../i18n';
import { DownOutlined } from '@ant-design/icons';

const LanguageSelector = () => {
  const languages = [
    { code: 'en', label: 'English' },
    { code: 'vn', label: 'Vietnamese' }
  ];

  const menu = (
    <Menu>
      {languages
        .sort((a, b) => a.code.localeCompare(b.code))
        .map((lang) => (
          <Menu.Item
            key={lang.code}
            onClick={() => i18n.changeLanguage(lang.code)}
            className="flex items-center gap-2"
          >
            <img
              src={`/icon/flags/${lang.code}.png`}
              alt={`${lang.label} flag`}
              className="w-4 h-4"
            />
            {lang.label}
          </Menu.Item>
        ))}
    </Menu>
  );

  return (
    <Dropdown overlay={menu}>
      <a className="ant-dropdown-link flex items-center gap-2" onClick={e => e.preventDefault()}>
        <img
          src={`/icon/flags/${i18n.language}.png`}
          alt={`Current language flag`}
          className="w-4 h-4"
        />
        {languages.find(lang => lang.code === i18n.language)?.label}
        <DownOutlined />
      </a>
    </Dropdown>
  );
};

export default LanguageSelector;