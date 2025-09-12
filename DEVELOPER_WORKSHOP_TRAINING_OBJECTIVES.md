# Zero Touch Developer "Up to Speed" Workshop

## Purpose
Comprehensive training program to bring demo.redhat.com developers up to speed on Zero Touch lab development essentials.

## Target Audience
**Internal Red Hat Developers** with existing backend knowledge who need to quickly understand Zero Touch lab development differences and patterns.

## Core Learning Objectives

### **Objective 1: Understand Zero Touch vs Traditional Lab Distinction**

#### **Learning Goal**
Recognize the fundamental architectural and business differences that drive Zero Touch design decisions.

#### **Key Insights**

**Business Context - Why Zero Touch Exists:**
- **Project Zero Initiative**: "Customer Self-Service Labs" to reduce Red Hat costs and replace Instruqt
- **Strategic Goal**: Migrate content from Instruqt to redhat.com/interactive-labs before 2026 contract renewal
- **Cost Reduction**: Primary business driver to avoid Instruqt licensing costs
- **Developer Experience**: Create "easy-to-use instruction authoring system for BU developers"
- **BU Autonomy**: Separate repositories enable business units to merge PRs and create catalog resources independently
- **Infrastructure Efficiency**: CNV virtualization eliminates per-instance costs compared to AWS EC2

**Lab Type Comparison:**

[cols="1,1,1"]
|===
|**Aspect** |**Traditional Labs (Internal)** |**Zero Touch Labs (Public)**

|**Audience**
|Solution architects, consultants, sales, marketing teams
|Public educational content for redhat.com/interactive-labs

|**Infrastructure**
|AWS EC2 virtual machines (`cloud_provider: ec2`) in sandboxed environments
|CNV virtualization (`cloud_provider: openshift_cnv`) within OpenShift

|**Security**
|Basic internal access controls
|Strict networking + content gateway for public internet protection

|**Cost Model**
|EC2 infrastructure costs acceptable for internal business use
|CNV virtualization eliminates per-instance costs vs AWS EC2

|**Repository Pattern**
|Static `showroom_git_repo`
|Dynamic `ocp4_workload_showroom_content_git_repo` with runtime fetching

|**Content Management**
|Central agnosticv/ repository requiring team interaction for releases
|BU-specific repositories (zt-rhelbu-agnosticv, zt-ansiblebu-agnosticv) enabling autonomy

|**Release Process**
|Platform team dependency, coordination required
|BU developers can merge their own PRs, create catalog resources independently

|**Strategic Purpose**
|Internal business use and demonstrations
|Replace Instruqt content with in-house solution, BU self-service
|=== 

#### **Visual Comparison**
**Repository Structure Differences:**

**Traditional Content Management:**
```
agnosticv/ (Central Repository)
├── zt_rhel/
│   ├── zt-user-basics/
│   │   ├── common.yaml (cloud_provider: ec2, showroom_git_repo)
│   │   ├── dev.yaml
│   │   └── prod.yaml
│   ├── zt-ans-bu-automation-controller/
│   ├── zt-ans-bu-writing-playbook/
│   └── zt-instructlab-rhel/
├── ansiblebu/
├── openshift_cnv/
├── sandboxes-gpte/
└── [15+ other directories]/
→ Requires platform team interaction for releases
```

**Zero Touch Content Management:**
```
zt-rhelbu-agnosticv/ (RHEL BU Autonomous)
├── common.yaml
├── includes/
└── zt-rhelbu/
    ├── zt-managing-user-basics/
    │   ├── common.yaml (cloud_provider: openshift_cnv, ocp4_workload_showroom_content_git_repo)
    │   ├── dev.yaml
    │   └── prod.yaml
    ├── zt-networking-basics/
    ├── zt-installing-software-yum/
    ├── zt-podman-basics/
    └── [30+ RHEL-specific labs]/

zt-ansiblebu-agnosticv/ (Ansible BU Autonomous)
├── common.yaml  
├── includes/
└── zt-ansiblebu/
    ├── zt-ans-bu-roadshow01/
    ├── zt-ans-bu-automation-controller/
    ├── zt-ans-bu-writing-playbook/
    └── [20+ Ansible-specific labs]/
→ BU full control, minimal platform team interaction
→ BU developers can merge their own PRs and create catalog resources independently
```

#### **Knowledge Check**
**Developer must explain:**
- Why Project Zero exists (Instruqt cost reduction, 2026 contract avoidance)
- Why Zero Touch uses CNV instead of AWS EC2 (cost efficiency, public scale, security)
- Why business units get separate repositories (BU autonomy, minimal team interaction for releases)
- How Zero Touch integrates with redhat.com/interactive-labs (Instruqt replacement strategy)
- Why content management autonomy matters (BU developers can merge PRs independently, create catalog resources without platform team approval)

#### **Success Criteria**
Developer can articulate the business and technical reasons for Zero Touch architectural decisions and identify the configuration differences that implement these requirements.

---

### **Objective 2: Master Critical Naming Conventions**
**Building on Objective 1's architectural understanding, this objective focuses on the specific naming patterns that make Zero Touch automation function correctly.**

#### **Learning Goal**
Understand the exact naming patterns that enable Zero Touch automation functionality and prevent common development failures.

#### **Key Insights**
- **Critical Naming Dependency**: Names must match exactly across AsciiDoc pages, runtime-automation directories, and ui-config.yml or automation breaks
- **Instance-Script Correspondence**: VM names in instances.yaml must match setup script names (setup-{instance_name}.sh pattern)
- **Case Sensitivity Requirements**: Exact character matching required, including hyphens and numbers
- **UI Automation Integration**: Solve buttons trigger scripts based on exact name matching
- **Production Pattern Recognition**: Real labs demonstrate consistent naming across all configuration files

**Example: zt-ans-bu-roadshow01**

**Module Name Correspondence:**
[cols="1,1,1"]
|===
|**AsciiDoc Pages** |**Runtime Automation** |**UI Config**

|`module-01.adoc`
|`runtime-automation/module-01/`
|`name: "module-01"`

|`module-02.adoc`
|`runtime-automation/module-02/`
|`name: "module-02"`

|`module-03.adoc`
|`runtime-automation/module-03/`
|`name: "module-03"`
|===

**Instance-to-Script Correspondence:**
[cols="1,1,1"]
|===
|**instances.yaml** |**setup-automation/** |**VM Purpose**

|`name: "control"`
|`setup-control.sh`
|Ansible controller (AAP 2.5)

|`name: "node01"`
|`setup-node01.sh`
|RHEL 9.5 managed node

|`name: "node02"`
|`setup-node02.sh`
|RHEL 8.7 managed node

|`name: "node03"`
|`setup-node03.sh`
|RHEL 9.5 managed node
|===

#### **Visual Examples**
**Complete zt-ans-bu-roadshow01 Structure (Production Zero Touch Lab on CNV):**
```
zt-ans-bu-roadshow01/
├── content/modules/ROOT/pages/
│   ├── module-01.adoc ("Backup and Snapshots")
│   ├── module-02.adoc ("Infrastructure Reporting")
│   └── module-03.adoc ("Windows Reporting")
├── runtime-automation/
│   ├── module-01/ (setup.sh, solve.sh, validation.sh)
│   ├── module-02/ (setup.sh, solve.sh, validation.sh)
│   ├── module-03/ (setup.sh, solve.sh, validation.sh)
│   ├── ansible.cfg
│   └── main.yml
├── setup-automation/
│   ├── setup-control.sh (AAP controller setup)
│   ├── setup-node01.sh (RHEL 9.5 node)
│   ├── setup-node02.sh (RHEL 8.7 node)
│   ├── setup-node03.sh (RHEL 9.5 node)
│   ├── ansible.cfg
│   └── main.yml
├── config/
│   ├── instances.yaml (4 VMs: control, node01, node02, node03)
│   ├── firewall.yaml
│   └── networks.yaml
├── ui-config.yml (modules: "module-01", "module-02", "module-03")
└── site.yml
```

**Key Naming Correspondences Demonstrated:**
- **Module naming**: `module-01.adoc` ↔ `module-01/` ↔ `name: "module-01"`
- **Instance naming**: `name: "control"` ↔ `setup-control.sh`
- **Multi-VM pattern**: 4 VMs each with corresponding setup script

#### **Knowledge Check**
**Developer must demonstrate:**
- Correct correspondence between AsciiDoc page names and runtime-automation directories
- Proper instance name to setup script mapping (setup-{instance_name}.sh)
- Understanding that mismatched names break UI button functionality
- Recognition of production vs template naming pattern differences
- Ability to identify functional vs documentation-only repository patterns

---

### **Objective 3: Configure VM and Container Infrastructure**
**Now that naming conventions are understood, this objective applies those patterns to actual infrastructure configuration using hands-on lab development.**
#### **Learning Goal**
Configure a RHEL VM with Cockpit web console and a bootc registry container, demonstrating Zero Touch multi-VM and container deployment with proper service exposure and OpenShift route configuration.

#### **Key Insights**
- **Naming Convention Enforcement**: VM names in instances.yaml must match setup script names (rhel → setup-rhel.sh)
- **Service Integration Pattern**: Both VMs and containers require services and routes for external showroom access
- **Container vs VM Deployment**: Containers use containerPort/targetPort while VMs use port/targetPort for service definitions
- **Showroom Security Configuration**: Web services require specific Origins configuration with GUID/DOMAIN variables for iframe integration
- **Certificate Conflict Prevention**: Setup scripts must remove application certificates to prevent conflicts with OpenShift TLS Edge termination
- **OpenShift TLS Management**: Routes with Edge termination handle all certificate management automatically

#### **Hands-on Exercise**

**Step 1: Create Lab Repository from Template**
1. Navigate to https://github.com/rhpds/lab_zero_touch_template.git
2. Click "Use This Template" to create your lab repository
3. Clone the repository locally for configuration

**Step 2: Configure Additional RHEL VM**
Add the following VM configuration to instances.yaml:

```yaml
virtualmachines:
  - name: "rhel"
    image: "rhel-9.6"
    bootloader: efi
    memory: "4G"
    cores: 1
    image_size: "40G"
    packages:
      - git
      - cockpit
    tags:
      - key: "AnsibleGroup"
        value: "bastions"
    networks:
      - default
    services:
      - name: cockpit
        ports:
          - port: 9090
            protocol: TCP
            targetPort: 9090
            name: cockpit
    routes:
      - name: cockpit
        host: cockpit
        service: cockpit
        targetPort: 9090
        tls: true
        tls_termination: Edge
```

**Step 3: Configure VM Setup Script**
1. Rename setup-host1.sh to setup-rhel.sh (matching VM name)
2. Replace content with Cockpit showroom integration:

```bash
#!/bin/bash
# Enable cockpit functionality in showroom.
echo "[WebService]" > /etc/cockpit/cockpit.conf
echo "Origins = https://cockpit-${GUID}.${DOMAIN}" >> /etc/cockpit/cockpit.conf
echo "AllowUnencrypted = true" >> /etc/cockpit/cockpit.conf
# Remove existing cockpit certificates to prevent TLS conflicts with OpenShift
rm -rf /etc/cockpit/ws-certs.d/* 2>/dev/null || true

systemctl enable --now cockpit.socket

dnf remove -y cockpit-composer
```

**Step 4: Configure Registry Container**
Add the following container configuration to instances.yaml:

```yaml
containers:
  - name: "bootc-registry"
    image: "quay.io/mmicene/registry:2"
    memory: "1G"
    cpu: "1"
    ports:
      - name: bootc-registry
        containerPort: 5000
        protocol: TCP
    environment:
      REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY: "/var/lib/registry"
      REGISTRY_HTTP_ADDR: "0.0.0.0:5000"
      REGISTRY_PULL_TOKEN: "{{ lookup('ansible.builtin.env', 'REGISTRY_PULL_TOKEN') | default('') }}"
      GUID: "{{ guid }}"
      DOMAIN: "{{ domain }}"
    volumes:
      - name: registry-data
        emptyDir: {}
    volumeMounts:
      - name: registry-data
        mountPath: "/var/lib/registry"
    services:
      - name: bootc-registry
        ports:
          - port: 5000
            protocol: TCP
            targetPort: 5000
            name: bootc-registry
    routes:
      - name: bootc-registry
        host: bootc-registry
        service: bootc-registry
        targetPort: 5000
        tls: true
        tls_termination: Edge
```

#### **Knowledge Check**
- What is the critical naming relationship between VM names and setup scripts?
- How do service definitions differ between containers and VMs in Zero Touch?
- Why is the Origins configuration required for Cockpit showroom integration?
- What networking components enable external access to lab services?

#### **Success Criteria**
- Create properly structured instances.yaml with RHEL VM and bootc registry container configurations
- Configure setup-rhel.sh with correct Cockpit Origins settings and service enablement
- Demonstrate understanding of Zero Touch naming conventions (rhel VM → setup-rhel.sh)
- Apply proper service and route definitions for external showroom access
- Explain differences between VM and container port configuration patterns

---

### **Objective 4: Implement Public Lab Security**
**With infrastructure configured in Objective 3, this objective secures those services for public internet exposure using Zero Touch security patterns.**

#### **Learning Goal**
Configure firewall.yaml rules for the Cockpit web console (port 9090) and bootc registry (port 5000) services from Objective 3, demonstrating network lockdown timing and public lab security patterns.

#### **Key Insights**
- **Post-Deployment Lockdown**: Network restrictions applied AFTER all package installation and service configuration complete
- **Deployment Phase Access**: VMs maintain full internet access during AgnosticD software phase for package installation
- **Service Port Management**: Custom services require explicit firewall.yaml configuration for external showroom access
- **Production Security Pattern**: Default web ports (80, 443) remain open while additional services need explicit configuration

#### **Hands-on Exercise**

**Step 1: Create firewall.yaml Configuration**
Building on Objective 3's Cockpit and registry services, create `config/firewall.yaml`:

```yaml
---
# Production pattern from zt-ans-bu-roadshow01
# Configure additional ports for Cockpit and registry access
egress:
  - ports:
      - protocol: TCP
        port: 443  # Showroom outbound
ingress:
  - ports:
      - protocol: TCP
        port: 9090  # Cockpit Console
  - ports:
      - protocol: TCP
        port: 5000  # bootc registry
```

**Step 2: Understand Network Lockdown Timing**
Critical deployment sequence understanding:

1. **Infrastructure Phase**: VMs and containers created with full network access
2. **Software Phase**: Packages installed, services configured with internet connectivity
3. **Service Setup**: Cockpit configured, registry initialized, all with open networking
4. **Network Lockdown**: firewall.yaml rules applied at END of post_software.yml
5. **External Access**: Services accessible via routes (cockpit-${guid}.${domain}, bootc-registry-${guid}.${domain})

**Step 3: Verify Production Security Pattern**
- **Default Ports**: 80, 443, 8080, 7171, 8081, 9000 remain accessible
- **Custom Services**: Additional ports (9090, 5000) explicitly configured
- **Bidirectional Rules**: Both ingress and egress configured for service functionality
- **Git Repository Timing**: Configuration must exist in repository before deployment starts

#### **Knowledge Check**
- What is the timing relationship between service configuration and network lockdown application?
- Which default web ports remain accessible after firewall.yaml rules are applied?
- Why do both ingress and egress rules need to be configured for service functionality?
- What routes are created for the Cockpit and registry services configured in this exercise?

#### **Success Criteria**
- Create properly structured firewall.yaml with ports 9090 and 5000 for Objective 3 services
- Demonstrate understanding of post-deployment lockdown timing sequence
- Explain relationship between OpenShift routes and firewall port configuration
- Configure both ingress and egress rules following production security patterns

---

### **Objective 5: Create Functional Showroom Interface**
**Completing the lab development workflow, this objective integrates the secured infrastructure from Objectives 3-4 into a functional showroom interface for end users.**

#### **Learning Goal**
Configure ui-config.yml to integrate the Cockpit web console and terminal access with the showroom interface, demonstrating external service tabs and solve button functionality for interactive lab experiences.

#### **Key Insights**
- **External Service Integration**: Tabs can reference external services using variable substitution (${guid}, ${domain})
- **Module Solve Buttons**: solveButton: true enables interactive automation for guided learning experiences
- **URL Pattern Consistency**: External service URLs must match the routes configured in instances.yaml
- **Terminal Integration**: wetty provides secure SSH access through showroom interface tabs with multi-user support (root, rhel)
- **Showroom Proxy Architecture**: Showroom nginx container routes tab URLs to internal services (/wetty_rhel → localhost:8002, /terminal → localhost:7681)
- **Internal Communication**: All showroom containers communicate via localhost for zero-latency service integration

#### **Hands-on Exercise**

**Step 1: Review Current ui-config.yml Structure**
Examine the lab_zero_touch_template ui-config.yml:

```yaml
---
antora:
  name: modules
  dir: www
  modules:
    - name: module-01
      label: "Writing your lab"
      solveButton: true
    - name: module-02
      label: "Antora"
      solveButton: true
    - name: module-03
      label: "Tabs"

tabs:
  - name: ">_ terminal"
    url: /wetty_rhel/ssh/root
```

**Step 2: Add External Service Tabs**
Building on Objectives 3 and 4's Cockpit and registry services, modify the tabs section to ui-config.yml:

```yaml
tabs:
  - name: ">_ terminal"
    url: /wetty_rhel/ssh/root
  - name: ">_ rhel user"
    url: /wetty_rhel/ssh/rhel
  - name: "Web Console"
    url: https://cockpit-${guid}.${domain}/
#  - name: "Registry" # This Registry is empty
#    url: https://bootc-registry-${guid}.${domain}/ # Containers Follow same pattern
```

**Step 3: Configure Module Solve Buttons**
Ensure modules are properly configured for interactive experiences:

```yaml
antora:
  name: modules
  dir: www
  modules:
    - name: module-01
      label: "Configure Infrastructure"
      solveButton: true
    - name: module-02
      label: "Security Implementation"
      solveButton: true
    - name: module-03
      label: "Service Integration"
      solveButton: true
```

**Note**: Set `solveButton: false` for modules that provide information-only content without automated solve functionality.

**Step 4: Verify URL Pattern Consistency**
Confirm tab URLs match the service names from instances.yaml and understand variable resolution:

- **Route-to-Tab Relationship**: OpenShift routes defined in instances.yaml (cockpit, bootc-registry) become accessible URLs that tabs reference
- **Variable Resolution**: Showroom automatically substitutes ${guid} with lab instance ID and ${domain} with cluster domain during runtime
- **Internal vs External URLs**: Terminal tabs use internal wetty paths (/wetty_rhel/ssh/user) for secure container-to-VM SSH, while service tabs use external HTTPS URLs for web access
- **URL Patterns**: External service tabs follow https://service-${guid}.${domain}/ format matching OpenShift route conventions

#### **Knowledge Check**
- How do the tab URLs relate to the OpenShift routes configured in instances.yaml?
- What is the purpose of the solveButton: true configuration in modules?
- Why do terminal tabs use /wetty_rhel/ssh/user patterns instead of external URLs?
- How do ${guid} and ${domain} variables get resolved in the showroom interface?

#### **Success Criteria**
- Successfully configure tabs section with external service URLs matching Objective 3 routes
- Properly structure modules section with appropriate solve button functionality
- Demonstrate understanding of variable substitution patterns (${guid}, ${domain})
- Create complete ui-config.yml integrating terminal, Cockpit, and registry access

---

### **Objective 6: Deploy and Test Complete Lab Environment**
**Completing the full development cycle, this objective demonstrates the end-to-end process from local configuration to live lab deployment using demo.redhat.com.**

#### **Learning Goal**
Deploy the configured lab to production environment using the Developer Experience RHEL BU catalog, demonstrating the complete workflow from git repository to functional showroom interface.

#### **Key Insights**
- **Git Repository Requirements**: Full clone URL ending in ".git" required for AgnosticD integration
- **Branch Management**: Deployment pulls from specified branch containing configuration changes
- **Environment Preservation**: Toggle option prevents automatic cleanup on deployment failures for debugging
- **Production Catalog Integration**: Developer Experience catalog items provide standardized deployment templates that reference the zt-rhelbu-agnosticv configurations, connecting catalog UI to AgnosticV backend patterns
- **End-to-End Validation**: Live deployment confirms all configuration components work together correctly

#### **Hands-on Exercise**

**Step 1: Prepare Repository for Deployment**
1. Add all configuration files to git tracking:
   ```bash
   git add config/instances.yaml config/firewall.yaml setup-automation/setup-rhel.sh ui-config.yml
   ```
2. Commit changes with descriptive message:
   ```bash
   git commit -m "Configure RHEL VM with Cockpit, bootc registry, and showroom integration"
   ```
3. Push to remote repository:
   ```bash
   git push origin main
   ```

**Step 2: Access Developer Experience Catalog**
1. Navigate to https://demo.redhat.com
2. Log in with Red Hat credentials
3. Search for "Developer Experience RHEL BU" catalog item
4. Select the production version of the catalog item

**Step 3: Configure Deployment Parameters**
1. Locate the `git_repo` field in the deployment form
2. Replace default value with your repository's full clone URL (must end in ".git")
   - Example: `https://github.com/username/lab-repository.git`
3. Specify the branch containing your configuration changes (typically "main")
4. Enable "Preserve environment if failed" toggle for debugging capability
5. Review other deployment parameters (typically use defaults)

**Step 4: Deploy and Monitor**
1. Click "Order" to initiate deployment
2. Monitor deployment progress in demo.redhat.com interface
3. Wait for provisioning to complete (typically 3-5 minutes)
4. Access showroom URL when deployment status shows "Running"

**Step 5: Validate Deployment**
1. Access the showroom interface through provided URL
2. Verify all configured tabs are present:
   - Terminal access (root and rhel user)
   - Cockpit web console
   - Registry interface
3. Test external service functionality:
   - Cockpit console loads and displays system information
   - Registry interface is accessible
   - Terminal connections work for both users
4. Confirm firewall rules are applied (services accessible externally)

**Step 6: Troubleshoot Common Issues (If Needed)**
- **"TLS certificate" errors**: Verify setup script removes /etc/cockpit/ws-certs.d/* certificates (primary cause)
- **Cockpit login failures**: Check Origins configuration matches route URL (cockpit-${GUID}.${DOMAIN})
- **Empty variable substitution**: Verify GUID/DOMAIN environment variables in setup container logs
- **Service connection failures**: Verify service selectors match VM labels (vm.cnv.io/name: rhel)
- **Avoid Over-Configuration**: Simple certificate cleanup usually resolves TLS issues without complex proxy settings

#### **Knowledge Check**
- Why must the git repository URL end in ".git" for proper AgnosticD integration?
- What is the purpose of the "preserve environment if failed" toggle?
- How does the Developer Experience catalog relate to the AgnosticV configurations?
- What validation steps confirm the complete lab deployment is functional?

#### **Success Criteria**
- Successfully commit and push all lab configurations to git repository
- Navigate demo.redhat.com catalog and locate appropriate Developer Experience item
- Configure deployment with correct git repository URL and branch specification
- Complete end-to-end deployment resulting in functional showroom interface
- Validate all configured services (Cockpit, registry, terminals) are accessible and operational

## **Completion Criteria**
**Developer demonstrates mastery by:**
1. **Architectural Understanding**: Explaining Zero Touch business drivers, CNV vs EC2 benefits, and BU autonomy advantages
2. **Naming Convention Mastery**: Applying exact naming patterns across AsciiDoc pages, runtime-automation directories, ui-config.yml, and instance-to-script correspondence
3. **Infrastructure Configuration**: Creating complete instances.yaml with VM and container configurations, proper service definitions, and setup script integration
4. **Security Implementation**: Configuring firewall.yaml with correct port exposure, understanding post-deployment lockdown timing, and production security patterns
5. **UI Integration**: Building functional ui-config.yml with external service tabs, solve button configuration, and variable substitution patterns
6. **Production Deployment**: Successfully deploying complete lab environment through demo.redhat.com catalog, validating end-to-end functionality from git repository to live showroom interface

This focused approach enables rapid developer onboarding to Zero Touch lab development essentials.
