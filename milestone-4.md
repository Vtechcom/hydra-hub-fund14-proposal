# Project Closeout Report: Hydra Hub – SaaS Node Distribution System Phase 1

## Project Overview
* **Project Name and Project URL on IdeaScale/Fund**
* **Project Name:** Hydra Hub – SaaS Node Distribution System Phase 1
* **Funding & Challenge:** Fund 14 - Cardano Use Cases: Concept
* **Project URL:** https://milestones.projectcatalyst.io/projects/1400060
* **Your Project Number:** 1400060
* **Project Manager Name:** Nguyen Viet Thanh
* **Project Start Date:** November 24, 2025
* **Project Completion Date:** May 15, 2026

---

## List of Challenge KPIs and How the Project Addressed Them
Challenge F14: Cardano Use Cases: Concept requires lowering the technical barriers when building on the Cardano platform and demonstrating the feasibility of new concepts.

We addressed these objectives by:
* **Minimizing L2 deployment barriers:** Transforming the complex process of setting up a Hydra Node into a simple Software as a Service (SaaS) model. End-users can now own and operate a Hydra Head without needing in-depth knowledge of DevOps or infrastructure configuration.
* **Illustrating viable real-world use cases:** Opening opportunities for game and dApp developers to easily leverage Hydra to achieve high throughput via our distribution system. This was practically proven with the launch of the Hydra One application alpha version.

---

## List of Project KPIs and How the Project Addressed Them
The project successfully completed its core KPIs through a strictly managed execution process:

**1. Execution schedule and time allocation:** The project was deployed across 4 phases (corresponding to 4 milestones) over a period of nearly 6 months.
* **Workflow overview:** Architecture design -> Smart contract development (validator) -> Backend Engineering & DevOps -> User interface development (Frontend) -> Integration & Deployment on testnet.
* **Team collaboration:** The team was divided into three main units (Smart Contracts, Backend/Operations, User Interface). We used weekly synchronization meetings to ensure API endpoints and validation logic perfectly matched the user interface. Debugging was performed cross-departmentally: the User Interface team reported state issues, the Backend team checked node logs, and Smart Contract developers adjusted on-chain logic accordingly.
* **Detailed time allocation:**
    * **Validator (Smart Contracts):** Took approximately 1.5 months to write, optimize, and conduct internal testing to ensure secure UTxO lock/unlock logic on the network.
    * **Backend & DevOps:** Took approximately 2.5 months. This was the heaviest workload, including message queue logic (RabbitMQ), NestJS modular architecture, and automated configuration packaging for Hydra Nodes.
    * **User Interface/User Experience (UI/UX):** Took approximately 1.5 months to design the interface, connect APIs, and integrate e-wallets.
    * **Remaining time (~0.5 months):** Dedicated to comprehensive testing, bug fixing, and preparing the acceptance environment for Catalyst reviewers.

**2. Completed technical KPIs:**
* A fully automated Backend system capable of generating Hydra Heads with a custom number of nodes.
* A smoothly functioning billing and account upgrade (Subscription) system.
* Ensuring a live, transparent testing environment for milestone reviewers, replacing static screenshots with interactive functionality.

---

## Key Achievements (Especially Regarding Collaboration and Engagement)
* **The emergence of Hydra One:** An unexpected but highly valuable expanded achievement is the successful development of https://alpha.hydraone.app/ — a real-world use case that inherits the node distribution capabilities of Hydra Hub. It allows dApp and Game developers to seamlessly combine blockchain transparency with the lightning-fast speed of Hydra.
* **Interaction with reviewers:** We maintained a candid and constructive dialogue with Catalyst reviewers throughout the review process (especially in Phase 1). This feedback loop helped shift our mindset from "closed security" to providing a "secure yet transparent testing environment" for live testing, thereby building greater trust.

---

## Key Lessons Learned (Challenges and Technical Insights)
Building Hydra Hub provided our team with invaluable insights, particularly when tackling the complex technical challenges of Cardano and Hydra:

**1. Overcoming technical challenges:**
* **UTxO and Slot Handling in the Validator:** The most difficult challenge was resolving the `OutsideValidityIntervalUTxO` error and managing the conceptual differences in Slots between Layer 1 and Layer 2. Synchronizing the valid time limits of transactions passing through the Hydra Validator requires extreme precision; otherwise, transactions will be rejected by the Hydra node.
* **Port routing for individual nodes:** Each generated Hydra node requires an independent and secure communication channel. Managing this becomes difficult as the number of nodes increases. Our breakthrough solution was integrating Kong Gateway to dynamically route APIs for each specific node, helping manage traffic and secure endpoints highly efficiently.
* **Frontend (FE) challenges:** Maintaining the real-time state of multiple simultaneous Hydra nodes on the user interface required us to handle complex WebSocket connections. The FE team had to heavily optimize the state management mechanism to prevent browser memory leaks.

**2. Lessons learned from developing applications with Hydra:**
* **Validator development with Aiken:** We made a strategic decision to use Aiken instead of traditional Plutus Tx. Aiken offers a much friendlier development experience, faster compilation, and readable syntax. Our conclusion is that the developer community should strongly transition to using Aiken for L2 projects.
* **The crucial importance of auditing validators:** Although Hydra operates on L2, the governance state (Commit/Decommit) of the validators remains on the main chain. We found that internal testing is not enough; scheduling rigorous smart contract audits is mandatory before moving the system to the mainnet to prevent any risk of users losing funds.

---

## Next Steps for the Developed Product or Service
* **Optimization & Mainnet Launch:** Conclude Phase 1, conduct a comprehensive audit of Aiken Validators, and prepare for the deployment of Hydra Hub on Mainnet.
* **Expanding the Hydra One ecosystem:** Proactively promote Hydra One to the game developer and Dapp developer communities with projects requiring high-volume microtransactions, real-time auctions, or high-frequency trading DeFi. This aims to attract developers to participate in building and experimenting with Hydra, thereby promoting the use of Hydra Hub. This will be how Hydra Hub proves the value of the Managed Heads model in delivering deployment capabilities and optimization for developers. 62]
* **Server system upgrade:** Deploy automated scaling features and remove idle nodes to optimize server infrastructure costs.
* **Proceeding with Phase 2 development:** Analyze and break down tasks to begin developing Phase 2 of the project, aiming to incorporate external server infrastructure operators capable of contributing nodes directly to Hydra Hub.

---

## Conclusion / Final Remarks
We have successfully transformed complex concepts in Hydra documentation into an intuitive, interactive SaaS platform. This project proves that Cardano is fully capable of supporting high-speed applications through Layer-2 solutions. We are immensely grateful to the Project Catalyst fund for giving us the opportunity to contribute to the ecosystem's development.

---

## Links to Other Relevant Sources or Project Documentation
* **Hydra One:** https://alpha.hydraone.app with 3 applications currently available that utilize Node provisioning capabilities from Hydra Hub for deployment. And in the near future, many additional applications will be released.
* **Analysis and community sharing articles:**
    * https://forum.cardano.org/t/hydra-hub-and-the-trust-layer-elevating-trust-for-every-dapp-using-hydra/152659
    * https://forum.cardano.org/t/leios-hydra-a-perfect-pair-unlocking-the-high-speed-low-fee-era-on-cardano/152332
    * https://forum.cardano.org/t/beyond-bridges-unlocking-true-interoperability-between-bitcoin-lightning-and-cardano-hydra/152501/4
* **Catalyst Milestone Platform:** https://milestones.projectcatalyst.io/projects/1400060
* **Link to summary video**
    * YouTube/Vimeo Link: https://youtu.be/zK4M-yxFMzs
