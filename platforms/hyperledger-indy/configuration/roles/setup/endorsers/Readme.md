## setup/endorsers
This role creates the deployment files for endorsers and pushes them to repository.

## Tasks:
### 1. Wait for namespace creation
This task checking if namespaces for identities of organizations are created.
This task calls role from *check/k8_component*
#### Input Variables:
 - component_type: Set, which type of k8s component may be created. Default a value *Namespace*.
 - component_name: Name of component, which it may check. It use a variable {{ component_ns }}
### 2. Create image pull secret for identities
This task create pull secret of each identity of organization.
This task calls role from *create/imagepullsecret*
### 3. Create Deployment files for Identities
This task creates Helm releases Indy Ledger Transaction Job for Endorsers Identities.
It calls a nested_main.yaml task.
#### Input Variables:
 - component_type: Set, which type of k8s component may be created. Default value *node*.
 - component_name: Name of Helm release. Default value is {{ organization }}-{{ stewardItem.name }}-node
 - indy_version: Version of Hyperledger Indy Node. Default value is indy-{{ network.version }}
 - release_dir: Release directory, where are stored generated files for gitops. Default value: {{ playbook_dir }}/../../../{{ gitops.release_dir }}
 - org_vault_url: Vault URL of organization

---------------------------------------------------------------------------------------
nested_main.yaml

### 1. Select Admin Identity for Organisation {{ component_name }}
This tasks selects the admin identity for a particular organization.

### 2. Calling Helm Release Development Role...
It calls the helm release development role for for creation of deployment file.
#### Input Variables:
 - component_type: "Set, which type of k8s component may be created."
-  component_name: "Name of the component"
-  indy_version: "Network version of indy"
-  release_dir: "Release directory in which the deployment file is saved"
- component_ns: "Namespace of the component"
-  newIdentityName: "Name of identity endorser to be added"
-  newIdentityRole: "Role of the endorser"
-  adminIdentityName: "Name of admin identity"
-  admin_component_name: "Name of admin Identity's Organization"
-  admin_org_vault_url: "Admin Org's Vault URL"
-  new_org_vault_url: "New Identity's vault URL"
-  new_component_name: "Name of New Identity's Organization"
- admin_type: "Type of Admin Identity"
- identity_type: "Type of identity to be added"

### 3. Push the created deployment files to repository
This task pushes generated Helm releases into remote branch.
This task calls role from: *{{ playbook_dir }}/../../shared/configuration/roles/git_push*
#### Input Variables:
 - GIT_DIR: A path of git directory. By default "{{ playbook_dir }}/../../../"
 - GIT_REPO: Url for git repository. It uses a variable *{{ gitops.git_push_url }}* 
 - GIT_USERNAME: Username of git repository. It uses a variable *{{ gitops.username }}*
 - GIT_EMAIL: User's email of git repository. It uses a variable *{{ gitops.email }}*
 - GIT_PASSWORD: User's password of git repository. It uses a variable *{{ gitops.password }}*
 - GIT_BRANCH: A name of branch, where are pushed Helm releases. It uses a variable *{{ gitops.branch }}*
 - GIT_RESET_PATH: A path of git directory, which is reseted for committing. Default value is *platforms/hyperledger-indy/configuration*
 - msg: A message, which is printed, when the role is running.