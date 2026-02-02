# Hydra Hub – User Manual

## 1. Introduction

Hydra Hub is a management and operation platform for **Hydra Heads** on Cardano. It allows users to create Projects, configure Heads, manage Nodes/Participants, and monitor Hydra connection status in real time.

This document provides an **end-to-end** guide for users, from account registration to running a Hydra Head and successfully establishing a connection.

---

## 2. Sign Up & Sign In

### 2.1 Account Registration

* Access Hydra Hub at [https://hydrahub.io.vn/](https://hydrahub.io.vn/)

![user registration](../screenshots/home.PNg)

* Click **Sign up**

![user registration](../screenshots/Singup.PNg)

* Fill in the required account information and submit the request
* The account status will be **Pending** until approved by an Admin

### 2.2 Sign In

* After the account is approved by the Admin
* Sign in using your email and password

![user login](../screenshots/singin.PNG)

---

## 3. Admin Account Approval

> This step is for Admin users only

* Go to **Admin Dashboard → Account Requests**
* Review the list of pending accounts
* Click **Approve** to activate the account

![admin approve](../screenshots/3.1-admin-approve.PNG)

---

## 4. Project Management

### 4.1 Create a Project

* Open the **Projects** menu, where you can view the list of projects you have created
* Click **New Project**

  * By default, a project is automatically created when you register an account
  * To create and manage multiple projects, you may need to upgrade your plan

![projects](../screenshots/projects.PNG)

* Each Project includes a **Project API Key**, which is used to authenticate requests

### 4.2 Project API Key

* The API Key must be included in the request header:

```
X-Api-Key: <proj_0618****54d064dea>
```

---

## 5. Hydra Head

### 5.1 Create a Head

* Inside a Project, click **New Head**
* Configure the Head step by step:

  * **General**: Head name and environment (Preprod/Mainnet)

![create head](../screenshots/4.1-create-head.PNG)

* **Protocols**: Hydra version, contestation period, deposit period

![create head](../screenshots/4.2-create-head.PNG)

* **Keys**: Verification keys and persistence settings

![create head](../screenshots/4.3-create-head.PNG)

### 5.2 Head Status

* `Configured`: Configuration completed
* `Ready`: Ready to be started
* `Running`: Head is running

### 5.3 Available Actions

![head details](../screenshots/5.1-detail-head.PNG)

* **Details**: View Head details

![head details](../screenshots/5.2-detail-head.PNG)

* **Edit**: Edit the display name of the Head
* **Start / Stop**: Start or pause the Head
* **Restart**: Restart the Head
* **Delete**: Delete the Head

---

## 6. Node / Participant Management

* Each Head consists of multiple Participants
* Displayed information includes:

![node list](../screenshots/6.1-detail-node-in-head.PNG)

* Participant ID
* HTTPS URL
* Provider
* Status

### 6.1 Available Actions

* **Details**: View Node details
* **Hydra Connection**: Connect to the Hydra node

---

### 6.2 Node Details

The Node Details screen displays:

* Balance (ADA)
* Cardano Fund Address
* HTTP Endpoint
* WebSocket Endpoint
* Hydra Verification Key
* Fund Verification Key

![node details](../screenshots/6.2-detail-node-in-head.PNG)

---

## 7. Hydra Connection

### 7.1 Connect

* Select **Hydra Connection**
* The system opens a real-time WebSocket connection

![hydra connect](../screenshots/8.1-hydra-connect.PNG)

### 7.2 Status

* `Idle`
* `Initializing`
* `Connected`

![hydra status](../screenshots/8.2-hydra-connect.PNG)

### 7.3 Event Logs

Common events include:

* `Greetings`
* `NetworkConnected`
* `PeerConnected`
* `HeadIsInitializing`

![hydra logs](../screenshots/8.3-hydra-connect.PNG)

When the bottom-right corner shows **Connected (green)**, the Head is running successfully.

---

## 8. Notes & Best Practices

* Always keep your API Key secure
* Only start a Head when all Participants are in the `Ready` state
* Use Preprod for testing before deploying to Mainnet

---

## 9. Support

* Refer to the **Documentation** available in Hydra Hub
* Contact the operations team if you encounter any issues
