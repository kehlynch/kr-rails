import React from "react";

import styles from "../../styles/play/role.module.scss";

export enum RoleType {
  PARTNER = "partner",
  DECLARER = "declarer",
  FOREHAN = "forehand",
}
type RoleProps = {
  name: RoleType;
};

const Role = ({ name }: RoleProps) => {
  return (
    <div className={styles.container}>
      <div className={styles[name]}>
        <span className="sr-only">{name}</span>
      </div>
    </div>
  );
};

export default Role;