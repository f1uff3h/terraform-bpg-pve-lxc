variables {
  ct_node = "pve802"
  ct_os = "local-btrfs:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
  ct_os_type = "debian"
}

run "fail_no_os" {
  command = plan

  variables {
    ct_os = null
  }

  expect_failures = [
    proxmox_virtual_environment_container.ct
  ]
}

run "fail_ct_os_and_ct_os_upload" {
  command = plan

  variables {
    ct_os_upload = {
      source = "os2"
    }
  }

  expect_failures = [
    proxmox_virtual_environment_download_file.ct_template
  ]
}

run "fail_bootstrap_no_script" {
  command = plan

  variables {
    ct_bootstrap = {
      script1 = {}
    }
    ct_ssh_privkey = "./test_key"
    ct_init = {
      root_keys = ["mock Key"]
    }
    ct_net_ifaces = {
      eth0 = {
        name = "eth0"
        ipv4_addr = "38.0.101.76/24"
      }
    }
  }

  expect_failures = [
    terraform_data.bootstrap_ct
  ]
}

run "fail_bootstrap_no_iface" {
  command = plan

  variables {
    ct_bootstrap = {
      script1 = {
        script_path = "my_script.sh"
      }
    }
    ct_ssh_privkey = "./test_key"
    ct_net_ifaces = {}
  }

  expect_failures = [
    terraform_data.bootstrap_ct
  ]
}

run "fail_bootstrap_no_ipv4" {
  command = plan

  variables {
    ct_bootstrap = {
      script1 = {
        script_path = "my_script.sh"
      }
    }
    ct_ssh_privkey = "./test_key"
    ct_init = {
      root_keys = ["mock Key"]
    }
    ct_net_ifaces = {
      eth0 = {
        name = "eth0"
      }
    }
  }

  expect_failures = [
    terraform_data.bootstrap_ct
  ]
}

run "fail_bootstrap_no_ssh_public_key" {
  command = plan

  variables {
    ct_bootstrap = {
      script1 = {
        script_path = "my_script.sh"
      }
    }
    ct_ssh_privkey = "./test_key"
    ct_net_ifaces = {
      eth0 = {
        name = "eth0"
        ipv4_addr = "38.0.101.76/24"
      }
    }
  }

  expect_failures = [
    terraform_data.bootstrap_ct
  ]
}

run "fail_bootstrap_no_ssh_private_key" {
  command = plan

  variables {
    ct_bootstrap = {
      script1 = {
        script_path = "my_script.sh"
      }
    }
    ct_init = {
      root_keys = [
        "./test_key.pub"
      ]
    }
    ct_net_ifaces = {
      eth0 = {
        name = "eth0"
        ipv4_addr = "38.0.101.76/24"
      }
    }
  }

  expect_failures = [
    terraform_data.bootstrap_ct
  ]
}

run "success_basic_build" {
  variables {
    ct_init = {
      hostname = "test-basic"
    }
    ct_disk = { datastore = "local-btrfs" }
    ct_net_ifaces = {}
  }
}

run "success_bootstrap_build" {
  # below variable required in environment
  # TF_VAR_ct_net_ifaces = { eth0 = { name = "eth0", ipv4_addr = "<ipv4/CIDR>", ipv4_gw = "<gateway_ip>" }
  variables {
    ct_bootstrap = {
      script1 = {
        script_path = "./examples/basic_bootstrap/bootstrap.sh"
      }
    }
    ct_ssh_privkey = "./test_key"
    ct_disk = { datastore = "local-btrfs" }
    ct_init = {
      hostname = "test-bootstrap"
      root_keys = [
        file("./test_key.pub")
      ]
    }
  }
}
