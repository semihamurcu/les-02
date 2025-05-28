# Infrastructuur als Code (Terraform) – ESXi & Azure Deployment

## 2.1 Bronnen
https://leren.windesheim.nl/d2l/le/lessons/98305/topics/1223765

https://chatgpt.com/share/6836d5bc-58b8-8002-814f-97098108539c

---

## 2.2 Bestandenstructuur en toelichting

🔹 **variables.tf**  
In dit bestand definieer je alle variabelen die in de configuratie worden gebruikt, zoals geheugen, CPU, netwerknaam, datastore, SSH-keypad enz. Dit maakt het script dynamisch en makkelijk herbruikbaar.

🔹 **terraform.tfvars**  
Hier worden concrete waarden toegekend aan de variabelen die zijn gedefinieerd in `variables.tf`. Zo houd je de configuratie netjes gescheiden van de omgeving-specifieke instellingen.

🔹 **providers.tf**  
Geeft aan welke providers Terraform moet gebruiken.  
- `esxi`: voor lokale deployment op een hypervisor  
- `azurerm`: voor deployment in Microsoft Azure  
Ook authenticatie en connectie-instellingen worden hier afgehandeld.

🔹 **main.tf**  
Bevat de daadwerkelijke Terraform-resources zoals virtuele machines, netwerkinterfaces, cloud-init data en lokale outputs. In dit bestand staat de complete infrastructuurcode gedefinieerd.

🔹 **inventory.ini** (gegenereerd)  
Een Ansible-inventory bestand dat automatisch gegenereerd wordt met de IP-adressen van de VM’s. Dit wordt gegenereerd via een `local_file` resource in Terraform. Klaar voor configuratiemanagement via Ansible.

🔹 **cloud-init bestanden (metadata.yaml.tfpl, userdata.yaml)**  
Deze bestanden worden via CloudInit gebruikt om de VM’s automatisch te configureren bij de eerste boot, zoals user creation, SSH access, en package installaties.

---

## ✅ A. ESXi – Terraform deployment van 3 Ubuntu 24.04 VM’s

Je hebt een Terraform manifest gemaakt waarmee 3 Ubuntu VM’s op een lokale ESXi-host worden uitgerold met de volgende eigenschappen:

- ✅ Gebruik van Ubuntu 24.04 cloud image (.ova)
- ✅ 2 VM’s als webserver (`web1`, `web2`)
- ✅ 1 VM als databaseserver (`db1`)
- ✅ Elke VM heeft:
  - 1 vCPU
  - 2048MB RAM
  - Cloud-init configuratie
    - Een user met sudo zonder wachtwoord
    - Installatie van `wget` en `ntpdate`
    - Invoegen van een ED25519 publieke SSH-key
- ✅ IP-adressen worden automatisch opgeslagen in `inventory.ini`



# Opdracht 2A resultaat:

Zie 2A Resultaat.mp4

## 🧪 Terraform Commands

Voor het uitvoeren van beide deployments gebruik je de standaard Terraform-commando’s:

```bash
terraform init
terraform apply
