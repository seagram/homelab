<div align="center">

# homelab

A homelab for self-hosting open source software.

</div>

## Architecture Layers

- **Layer 1: Hardware** - Refurbished MacBook Pro (2015, Intel Core i7, 16GB DDR3 RAM).
- **Layer 2: Hypervisor** - Proxmox VE configured with Ansible and connected via Tailscale VPN.
- **Layer 3: Virtual Machines** - 3 VMs (1 control plane, 2 workers) provisioned via Terraform running Talos Linux (4GB RAM and 2 cores each)
- **Layer 4: Kubernetes** - Running a fully immutable, API-managed Kubernetes distribution with a entirely declarative configuration.

## Infrastructure Stack

<div align="center">

<table>
  <tr>
    <td align="center" width="200"><b>Infrastructure & Orchestration</b></td>
    <td align="center">
      <div style="display: inline-block; text-align: center; margin: 10px;">
        <img src="assets/terraform.svg" alt="Terraform" width="80" height="80"/><br/>
        <b>Terraform</b>
      </div>
      <div style="display: inline-block; text-align: center; margin: 10px;">
        <img src="assets/ansible.svg" alt="Ansible" width="80" height="80"/><br/>
        <b>Ansible</b>
      </div>
      <div style="display: inline-block; text-align: center; margin: 10px;">
        <img src="assets/docker.svg" alt="Docker" width="80" height="80"/><br/>
        <b>Docker</b>
      </div>
      <div style="display: inline-block; text-align: center; margin: 10px;">
        <img src="assets/kubernetes.svg" alt="Kubernetes" width="80" height="80"/><br/>
        <b>Kubernetes</b>
      </div>
    </td>
  </tr>
  <tr>
    <td align="center" width="200"><b>Virtualization & Operating Systems</b></td>
    <td align="center">
      <div style="display: inline-block; text-align: center; margin: 10px;">
        <img src="assets/proxmox.svg" alt="Proxmox" width="80" height="80"/><br/>
        <b>Proxmox</b>
      </div>
      <div style="display: inline-block; text-align: center; margin: 10px;">
        <img src="assets/linux.svg" alt="Talos Linux" width="80" height="80"/><br/>
        <b>Talos Linux</b>
      </div>
    </td>
  </tr>
  <tr>
    <td align="center" width="200"><b>Networking & Security</b></td>
    <td align="center">
      <div style="display: inline-block; text-align: center; margin: 10px;">
        <img src="assets/cloudflare.svg" alt="Cloudflare" width="80" height="80"/><br/>
        <b>Cloudflare</b>
      </div>
      <div style="display: inline-block; text-align: center; margin: 10px;">
        <img src="assets/tailscale.svg" alt="Tailscale" width="80" height="80"/><br/>
        <b>Tailscale</b>
      </div>
      <div style="display: inline-block; text-align: center; margin: 10px;">
        <img src="assets/caddy.svg" alt="Caddy" width="80" height="80"/><br/>
        <b>Caddy</b>
      </div>
      <div style="display: inline-block; text-align: center; margin: 10px;">
        <img src="assets/traefik-proxy.svg" alt="Traefik" width="80" height="80"/><br/>
        <b>Traefik</b>
      </div>
    </td>
  </tr>
  <tr>
    <td align="center" width="200"><b>Cloud & DevOps</b></td>
    <td align="center">
      <div style="display: inline-block; text-align: center; margin: 10px;">
        <img src="assets/aws.svg" alt="AWS" width="80" height="80"/><br/>
        <b>AWS</b>
      </div>
      <div style="display: inline-block; text-align: center; margin: 10px;">
        <img src="assets/fluxcd.svg" alt="FluxCD" width="80" height="80"/><br/>
        <b>FluxCD</b>
      </div>
    </td>
  </tr>
  <tr>
    <td align="center" width="200"><b>Monitoring & Observability</b></td>
    <td align="center">
      <div style="display: inline-block; text-align: center; margin: 10px;">
        <img src="assets/prometheus.svg" alt="Prometheus" width="80" height="80"/><br/>
        <b>Prometheus</b>
      </div>
      <div style="display: inline-block; text-align: center; margin: 10px;">
        <img src="assets/grafana.svg" alt="Grafana" width="80" height="80"/><br/>
        <b>Grafana</b>
      </div>
      <div style="display: inline-block; text-align: center; margin: 10px;">
        <img src="assets/grafanaloki.svg" alt="Loki" width="80" height="80"/><br/>
        <b>Loki</b>
      </div>
    </td>
  </tr>
  <tr>
    <td align="center" width="200"><b>Applications & Databases</b></td>
    <td align="center">
      <div style="display: inline-block; text-align: center; margin: 10px;">
        <img src="assets/n8n.svg" alt="n8n" width="80" height="80"/><br/>
        <b>n8n</b>
      </div>
      <div style="display: inline-block; text-align: center; margin: 10px;">
        <img src="assets/postgresql.svg" alt="PostgreSQL" width="80" height="80"/><br/>
        <b>PostgreSQL</b>
      </div>
    </td>
  </tr>
</table>

</div>

## Design Principles

- **100% declaritive** - Use IaC to ensure a fully automatable and reproducable workflow.
- **Single-dependency approach** - The only required dependency is Docker.
- **Zero-trust networking** - No passwords or passkeys. All authentication encrypted through a VPN.
