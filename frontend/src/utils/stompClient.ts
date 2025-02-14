import { Client } from "@stomp/stompjs";

export const stompClient = new Client({
  //   brokerURL: `${WS_BACK_END}/8lind8ox-ws`,
  brokerURL: `ws://localhost:8080/8lind8ox-ws`,
  onConnect: () => {
    console.log("Connected ");
  },
  onDisconnect: () => {
    console.log("Disconnected ");
  },
  onWebSocketClose: (closeEvent) => {
    console.log("WebSocket closed: ", closeEvent);
  },
  onStompError: (error) => {
    console.error(
      "Could not connect to WebSocket server. Please refresh this page to try again!",
      error
    );
  },
  maxWebSocketChunkSize: 1024 * 1024 * 10,
});
stompClient.activate();
