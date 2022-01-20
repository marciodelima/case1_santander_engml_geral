terraform {
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
      version = "0.1.8"
    }
  }
}

provider "azuredevops" {
  personal_access_token="2olvfwxlvd7hb4xcgw23wlnne52xzrvwtfeaxtbkqd4nk5oeisnq"
  org_service_url="https://dev.azure.com/marciodelima1301"
}

resource "azuredevops_project" "project" {
  name               = "case_heart_frontend"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"
}

resource "azuredevops_project" "projectback" {
  name               = "case_heart_backend"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"
}

resource "azuredevops_serviceendpoint_generic_git" "serviceendpointF" {
  project_id            = azuredevops_project.project.id
  repository_url        = "https://github.com/marciodelima/case1_santander_engml_frontend.git"
  username              = "marcio_de_lima@yahoo.com.br"
  password              = "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"
  service_endpoint_name = "FrontEnd"
  description           = "GitHub - Case1 - Santander - FrontEnd"
}

resource "azuredevops_serviceendpoint_generic_git" "serviceendpointB" {
  project_id            = azuredevops_project.projectback.id
  repository_url        = "https://github.com/marciodelima/case1_santander_engml_backend.git"
  username              = "marcio_de_lima@yahoo.com.br"
  password              = "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"
  service_endpoint_name = "BackEnd"
  description           = "GitHub - Case1 - Santander - BackEnd"
}

resource "azuredevops_git_repository" "repoF" {
  project_id = azuredevops_project.project.id
  name       = "FrontEnd"
  initialization {
    init_type             = "Import"
    source_type           = "Git"
    source_url            = "https://github.com/marciodelima/case1_santander_engml_frontend.git"
    service_connection_id = azuredevops_serviceendpoint_generic_git.serviceendpointF.id
  }
}

resource "azuredevops_git_repository" "repoB" {
  project_id = azuredevops_project.projectback.id
  name       = "BackEnd"
  initialization {
    init_type             = "Import"
    source_type           = "Git"
    source_url            = "https://github.com/marciodelima/case1_santander_engml_backend.git"
    service_connection_id = azuredevops_serviceendpoint_generic_git.serviceendpointB.id
  }
}


