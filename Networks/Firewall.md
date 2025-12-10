## 🔥 1. Firewall Rules (Classic VPC Firewall Rules)
These are the basic firewall rules that most people use in Google Cloud.
They apply directly to a VPC network.

#### ✔ Where they are used

  Inside a VPC:
  ```
  VPC → Firewall → Ingress/Egress rules
  ```

#### ✔ Characteristics
  * Simple
  * Free (no extra charge)
  * Best for most small and mid-size environments
  * Ordered by priority number (lower number = evaluated earlier)


## 🛡️ 2. Firewall Policies (Hierarchical Firewall Policies)
These are advanced, centrally managed firewalls used for enterprise environments.

They apply at organization, folder, or project level — not inside a VPC.
  ```
  Organization
      ↓
  Folder (optional)
      ↓
  Project
      ↓
  VPC Firewall Rules (classic)
  ```

#### ✔ What they do
  * Allow or deny traffic before VPC firewall rules are evaluated
  * Provide centralized security governance
  * Manage rules across multiple VPCs and projects

#### ✔ Types of Firewall Policies
  1. Organization Firewall Policies

     Apply to all projects under an org domain.
  3. Folder Firewall Policies

     Apply to all projects in a specific folder.
  5. Project-Level Firewall Policies

     Apply to a specific project (but still before VPC rules).
