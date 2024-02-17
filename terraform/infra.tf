terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "2.99.0"
        }
    }
}

provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "rg" {
    name     = "rg-terraform"
    location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
    name                = "vnet-terraform"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
    name                 = "subnet-terraform"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_public_ip" "publicip" {
    name                = "publicip-terraform"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
    name                = "nic-terraform"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
        name                          = "ipconfig-terraform"
        subnet_id                     = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.publicip.id
    }
}

resource "azurerm_managed_disk" "disk" {
    name                 = "datadisk-terraform"
    location             = azurerm_resource_group.rg.location
    resource_group_name  = azurerm_resource_group.rg.name
    storage_account_type = "Standard_LRS"
    create_option        = "Empty"
    disk_size_gb         = 20
}

resource "azurerm_virtual_machine" "vm" {
    name                  = "vm-terraform"
    location              = azurerm_resource_group.rg.location
    resource_group_name   = azurerm_resource_group.rg.name
    network_interface_ids = [azurerm_network_interface.nic.id]
    vm_size               = "Standard_B1s"

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    storage_os_disk {
        name              = "osdisk-terraform"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_data_disk {
        name              = azurerm_managed_disk.disk.name
        managed_disk_id   = azurerm_managed_disk.disk.id
        create_option     = "Attach"
        lun               = 0
        caching           = "ReadWrite"
        disk_size_gb      = azurerm_managed_disk.disk.disk_size_gb
    }

    os_profile {
        computer_name  = "hostname"
        admin_username = "adminuser"
        admin_password = "Password1234!"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }
}

resource "random_id" "random" {
    byte_length = 8
}

output "public_ip" {
    value = azurerm_public_ip.publicip.ip_address
}
