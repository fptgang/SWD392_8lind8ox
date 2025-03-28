import { InboxOutlined } from "@ant-design/icons";
import { useTranslation } from "@refinedev/core";
import { Button, message, Modal, notification, Upload } from "antd";
import { useState } from "react";
import api from "../../../../config/openapi-config";
import { store } from "../../../../store";
import { SlotDto } from "../../../../../generated";

interface VideoUploadModalProps {
  visible: boolean;
  onCancel: () => void;
  slot: SlotDto | undefined;
  refetch?: () => void;
}

export const VideoUploadModal: React.FC<VideoUploadModalProps> = ({
  visible,
  onCancel,
  slot,
  refetch,
}) => {
  const user = store.getState().auth.account;
  const [videoFile, setVideoFile] = useState<Blob | null>(null);
  const handleVideoUpload = async (file: Blob) => {
    await api
      .createVideo({
        accountId: user?.accountId,
        slotId: slot?.slotId,
        videoBlob: file,
        isVisible: true,
      })
      .then((res) => {
        notification.success({
          message: "Video Uploaded",
          description:
            "Your video has been uploaded successfully. The voucher will be issued shortly.",
        });
      });
  };
  const handleUpload = () => {
    if (videoFile) {
      handleVideoUpload(videoFile).then(() => {
        if (refetch) {
          refetch();
        }
        onCancel();
        setVideoFile(null);
      });
    } else {
      message.error("Please select a video file first");
    }
  };

  const uploadProps = {
    name: "file",
    multiple: false,
    accept: "video/*",
    beforeUpload: (file: any) => {
      setVideoFile(file);
      return false;
    },
    onRemove: () => {
      setVideoFile(null);
    },
  };

  return (
    <Modal
      title={`Upload Video for Slot #${slot?.position}`}
      open={visible}
      onCancel={onCancel}
      footer={[
        <Button key="cancel" onClick={onCancel}>
          Cancel
        </Button>,
        <Button
          key="upload"
          type="primary"
          onClick={handleUpload}
          disabled={!videoFile}
        >
          Confirm Upload
        </Button>,
      ]}
    >
      <Upload.Dragger
        {...uploadProps}
        fileList={videoFile ? [videoFile as any] : []}
        multiple={false}
      >
        <p className="ant-upload-drag-icon">
          <InboxOutlined />
        </p>
        <p className="ant-upload-text">
          Click or drag video file to this area to upload
        </p>
        <p className="ant-upload-hint">
          Upload a video for your slot to get a voucher
        </p>
      </Upload.Dragger>
    </Modal>
  );
};
