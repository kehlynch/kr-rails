import React, { useState } from "react";
import Button from "react-bootstrap/Button";

/* eslint-disable */
// @ts-ignore
import { ActionCableConsumer } from '@thrash-industries/react-actioncable-provider';
/* eslint-enable */

import { sendMessage } from "../api";


const Test = (): React.ReactElement => {
  const [message, setMessage] = useState();
  // connectToTestChannel(setMessage);

  const handleMessage = (data: any) => {
    console.log("received", data);
    setMessage(data.message);
  }


  return (
    <ActionCableConsumer
        channel="TestChannel"
        onReceived={handleMessage}
      >
      <Button variant="primary" onClick={sendMessage}>send message</Button>
      <div>
        { message }
      </div>
    </ActionCableConsumer>
  );
};

export default Test;
