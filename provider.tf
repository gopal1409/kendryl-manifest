#all the default region which is dev test or stagin area
provider "azurerm" {
  features {
    virtual_machine {
      #delete_os_disk_on_deletion = false 
    }
  }
}

####this is for prod area
provider "azurerm" {
  features {
    virtual_machine {
      delete_os_disk_on_deletion = false 
    }
  }
  alias = "provider2-westus"
 # client_id = "xxxx"
 # client_secret = "yyyyy"
 # environment = "german"
  #subscription_id = "sajnfdsajfkjsaf"
}


##when i delete a vm in azure the storage get deleted. os disk get delete
###there are secnarion where i dont want os disk get deleted
###terraform required provider block
###if i do first time terraform init. 
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}
