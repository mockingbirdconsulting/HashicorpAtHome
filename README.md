# Hashicorp at Home

This is the code to accompany the "[Hashicorp At Home](https://www.mockingbirdconsulting.co.uk/blog/2019-01-05-hashicorp-at-home/)" series on our website.

## How to use this repository

1. Clone the repository onto the machine you'll use to deploy the software to the server
2. Install [Ansible](https://www.ansible.com)
3. Use Ansible Galaxy to install the roles listed in part two of the series.  Run it from the cloned directory and ansible will put them in the correct location.
4. Update `inventory/hosts` and set the target IP Address to the ip address you are using for your server
5. Update `plays/home_server.yml` and set the following4
  * All variables ending in `_domain` must be set to the same value

   This is the domain that you will use to look up services on your network.  It defaults to `consul`

  * `consul_recursors` - The DNS servers you want to use for external lookups, we use the Google ones by default.
  * `nomad_vault_address` - Whilst we set this up, we won't have DNS running, so we need to hard-code the IP Address for the Vault server here.
6. Overwrite `ansible/roles/kibatic.traefik/templates/traefik.toml` based on the details in part 2 of the series
7. Follow the instructions on the blog post to create a Vault token for Nomad
8. Create two encrypted files using Ansible vault in the following locations (replacing the dummy values with the actual text):
  * `inventory/group_vars/all` containing `datadog_api_key: "My DataDog API Key"`
  * `inventory/group_vars/docker_instances` containing `nomad_vault_token: "My Vault Nomad Token"`
9. Execute Ansible against the playbook in `plays`

## Copyright and Licensing
All code in this repository remains the copyright of Mockingbird Consulting Ltd, however it is released to the community under the MIT License to allow adaptation and reuse.

If you find the code useful, please credit us in the project that you reuse it for.

Hashicorp, Vault, Consul, and Nomad are trademarks of Hashicorp Inc. and are used here to reference their product line only.  This project has *not* been endorsed by Hashicorp, nor is there any implied support, endorsement, or liability on Hashicorp's part to anyone who uses this software.
