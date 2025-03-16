import React, { useState, useEffect, useCallback } from "react";
import { Form, Select, Input } from "antd";
import ReactQuill from "react-quill";
import sanitizeHTML from "sanitize-html";
import "react-quill/dist/quill.snow.css";

const { Option } = Select;
const { TextArea } = Input;

interface WysiwygProps {
  initialValue?: string;
  contentLang?: string;
  className?: string;
  required?: boolean;
  requiredMessage?: string;
  maxlength?: number;
  counterWithTag?: boolean;
  maxlengthMessage?: string;
  taglessMessage?: string;
  allowHeadings?: boolean;
  allowColors?: boolean;
  allowSizes?: boolean;
  allowLists?: boolean;
  allowAlignments?: boolean;
  allowLinks?: boolean;
  disabled?: boolean;
  onChange?: (value: string) => void;
}

const WysiwygQuill: React.FC<WysiwygProps> = ({
  initialValue,
  required = true,
  maxlength = 65535,
  counterWithTag = true,
  allowHeadings = true,
  allowColors = true,
  allowSizes = false,
  allowLists = true,
  allowAlignments = true,
  allowLinks = true,
  onChange = () => {},
}) => {
  const [value, setValue] = useState<string>(initialValue || "");

  const handleChange = (content: string) => {
    setValue(content);
    onChange(content);
  };

  const modules = {
    toolbar: [
      allowHeadings ? [{ header: 1 }, { header: 2 }, { header: 3 }] : null,
      ["bold", "italic", "underline"],
      [{ script: "sub" }, { script: "super" }],
      allowSizes ? [{ size: [] }] : null,
      allowColors ? [{ color: [] }] : null,
      allowLists ? [{ list: "ordered" }, { list: "bullet" }] : null,
      allowAlignments ? [{ align: [] }] : null,
      allowLinks ? ["link"] : null,
      ["clean"],
    ].filter(Boolean),
  };

  const formats = [
    "header",
    "size",
    "bold",
    "italic",
    "underline",
    "list",
    "bullet",
    "indent",
    "link",
    "color",
  ];

  return (
    <>
      <ReactQuill
        modules={modules}
        formats={formats}
        readOnly={false}
        onChange={handleChange}
        defaultValue={value}
        placeholder="Enter text here"
      />
    </>
  );
};

export default WysiwygQuill;
