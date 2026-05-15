# Project Close-out Report: Hydra Hub – SaaS Node Distribution System Phase 1

## Name of project and Project URL on IdeaScale/Fund
**Project Name:** Hydra Hub – SaaS Node Distribution System Phase 1
**Fund & Challenge:** Fund 14 - Cardano Use Cases: Concept
**Project URL:** [https://milestones.projectcatalyst.io/projects/1400060](https://milestones.projectcatalyst.io/projects/1400060)

## Your Project Number
**1400060**

## Name of project manager
**[Your Name / Project Manager Name]** *Ania-Vtechcom*

## Date project started
**November 24, 2025**

## Date project completed
**May 15, 2026**

---

## List of challenge KPIs and how the project addressed them
The *F14: Cardano Use Cases: Concept* challenge requires lowering the technical barrier to entry for building on Cardano and proving the viability of new concepts. We addressed these goals by:
1. **Lowering L2 Deployment Barriers:** Transforming the complex process of setting up a Hydra Node into a streamlined Software-as-a-Service (SaaS). End-users can now own and operate a Hydra Head without needing advanced DevOps or infrastructure configurations.
2. **Demonstrating Viable Real-World Use Cases:** Opening the door for game and dApp developers to easily leverage Hydra for high throughput via our distribution system. This was practically demonstrated by the launch of the **Hydra One** alpha application.

## List of project KPIs and how the project addressed them
The project successfully completed its core KPIs through a strictly managed execution process:

**1. Execution Progress & Time Allocation:**
The project was rolled out across 4 stages (corresponding to 4 Milestones) over a period of nearly 6 months.
* **Workflow Overview:** Architecture Design -> Smart Contract (Validator) Development -> Backend & DevOps Engineering -> Frontend (FE) Development -> Integration & Testnet Deployment.
* **Team Collaboration:** The team was divided into three main units (Smart Contract, Backend/DevOps, Frontend). We utilized Weekly Syncs to ensure API endpoints and validator logic perfectly matched the user interface. Debugging was handled cross-functionally: the FE team reported state issues, the Backend team inspected node logs, and SC developers adjusted on-chain logic accordingly.
* **Detailed Time Allocation:**
    * **Validator (Smart Contracts):** Took approximately **1.5 months** to write, optimize, and conduct internal testing to ensure the lock/unlock UTxO logic was secure on the network.
    * **Backend & DevOps:** Took approximately **2.5 months**. This was the heaviest workload, involving message queue logic (RabbitMQ), NestJS modular architecture, and automated configuration packaging for Hydra Nodes.
    * **Frontend (UI/UX):** Took approximately **1.5 months** to design the interface, connect APIs, and integrate wallets.
    * **Remaining Time (~0.5 months):** Dedicated to end-to-end testing, bug fixing, and preparing the acceptance environment for Catalyst Reviewers.

**2. Completed Technical KPIs:**
* A fully automated Backend system capable of generating Hydra Heads with a custom number of nodes.
* A smoothly operating payment and account upgrade (Subscription) system.
* Ensured a live, transparent testing environment for Milestone Reviewers, replacing static screenshots with interactive functionality.

## Key achievements (in particular around collaboration and engagement)
* **The Emergence of Hydra One:** An unexpected but highly valuable extended achievement was the successful development of [Hydra One](https://alpha.hydraone.app)—a real-world use case that inherits the node distribution capabilities of Hydra Hub. It empowers dApp and Game developers to seamlessly blend blockchain transparency with Hydra's lightning-fast speeds.
* **Reviewer Engagement:** We maintained candid and constructive dialogue with Catalyst Reviewers during the assessment process (especially in Milestone 1). This feedback loop helped us shift our mindset from "closed security" to providing a "secure but transparent Sandbox" for direct testing, fostering greater trust.

## Key learnings (Technical Challenges & Insights)
Building Hydra Hub provided our team with invaluable insights, particularly when navigating the deep technical challenges of Cardano and Hydra:

**1. Overcoming Technical Challenges:**
* **Handling UTxOs and Slots in Validators:** The most difficult challenge was resolving the `OutsideValidityIntervalUTxO` error and managing the conceptual discrepancy of Slots between Layer 1 and Layer 2. Synchronizing the valid time bounds of transactions passing through the Hydra Validator requires extreme precision; otherwise, transactions are rejected by the Hydra node.
* **Gateway Routing for Individual Nodes:** Every spawned Hydra node requires an independent, secure communication pipeline. Managing this became difficult as the number of nodes scaled. Our breakthrough solution was integrating **Kong Gateway** to dynamically route APIs for each specific node, which managed traffic and secured endpoints highly effectively.
* **Frontend (FE) Hurdles:** Maintaining the real-time state of multiple Hydra nodes simultaneously on the UI required us to handle complex WebSocket connections. The FE team had to heavily optimize the state management mechanism to prevent browser memory leaks.

**2. Insights from Developing with Hydra:**
* **Validator Development with Aiken:** We made the strategic decision to use Aiken instead of traditional Plutus Tx. Aiken provided a much friendlier developer experience, faster compilation, and highly readable syntax. Our takeaway is that the developer community should strongly migrate toward Aiken for L2 projects.
* **The Critical Importance of Auditing Validators:** Even though Hydra operates on L2, the Validators governing state (Commit/Decommit) reside on the main chain. We learned that internal testing is insufficient; planning a rigorous **Smart Contract Audit** is mandatory before moving the system to Mainnet to prevent any risk of user fund loss.

## Next steps for the product or service developed
* **Optimization & Mainnet Launch:** Finalize Phase 1, conduct a comprehensive audit of the Aiken Validators, and prepare for the Mainnet deployment of Hydra Hub.
* **Expanding the Hydra One Ecosystem:** Actively promote Hydra One to the gaming community and projects requiring high-volume **micro-payments** or **real-time auctions** on Cardano.
* **Backend Upgrades:** Implement auto-scaling and teardown features for idle nodes to optimize server infrastructure costs.

## Final thoughts/comments
We have successfully translated the complex concepts of Hydra documentation into an intuitive, interactive SaaS platform. This project proves that Cardano is fully capable of supporting high-speed applications via Layer-2 solutions. We are immensely grateful to the Project Catalyst fund for giving us the opportunity to contribute to the expansion of the ecosystem.

## Links to other relevant project sources or documents
* **Hydra One Alpha:** [https://alpha.hydraone.app](https://alpha.hydraone.app)
* **Catalyst Milestone Platform:** [Project 1400060](https://milestones.projectcatalyst.io/projects/1400060)


## Link to Close-out video
* **YouTube/Vimeo Link:** *(https://www.youtube.com/watch?v=1Z6IT1ieAgw)*
