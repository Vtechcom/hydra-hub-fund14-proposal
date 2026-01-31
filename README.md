# Hydra Hub - Fund 14 Proposal

## Project Overview
**Hydra Hub** is a platform designed to simplify access to Hydra nodes for developers and end-users. This repository contains documentation, milestone reports, and evidence of completion for our Project Catalyst Fund 14 proposal.

The core objective is to build a scalable system consisting of a **Consumer Portal** for managing access requests and an **Admin Dashboard** for node allocation and monitoring.

## Milestone 1: Core System Development

Our first milestone focuses on establishing the core infrastructure and user interfaces.

### Key Components
1.  **Consumer Portal**: 
    *   User registration and secure authentication.
    *   Profile management.
    *   Submission interface for Hydra node access requests.
    *   Responsive design for Desktop and Mobile.

2.  **Admin Dashboard**:
    *   Review and approval workflows for user requests.
    *   Real-time monitoring of node allocation status.
    *   User management and activity logging.

### Functionality & Acceptance Criteria
*   **Role-Based Access Control (RBAC)**: Strict separation between Consumer and Admin roles.
*   **Node Allocation Control**: Admins can allocate or revoke node usage rights directly.
*   **System Integration**: Full backend integration with PostgreSQL database (managing users, requests, allocations).
*   **Compatibility**: Validated on Chrome v120+ and Safari v17+, supporting responsive layouts (1920x1080 and 375x812).

## Repository Structure

*   `milestone-1.md`: Completion report template and evidence for Milestone 1.
*   *(Future milestone reports will be added here)*

## Deployment & Testing

We maintain two environments for this phase:

*   **Alpha Testing Environment**: For functionality testing and user feedback.
*   **Backoffice Demo**: Restricted access for administrative workflows.

## API Overview

The system relies on a robust backend API handling key operations:

*   **Auth**: `/api/auth/register`, `/api/auth/login`
*   **Requests**: `GET/POST /api/requests`
*   **Admin**: `/api/admin/requests/:id`, `/api/admin/nodes`

---
*Submitted for Cardano Project Catalyst Fund 14*
