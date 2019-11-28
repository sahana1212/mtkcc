terraform {
	  backend "local" {
	    path = "/tmp/terraform/workspace/terraform.tfstate"
	  }
	}
	
	provider "aws" {
	  region = "eu-central-1"
	}
	
	resource "aws_instance" "backend" {
	  ami                    = "ami-050a22b7e0cf85dd0"
	  instance_type          = "t2.micro"
	  key_name               = "master-key"
	  vpc_security_group_ids = ["${var.sg-id}"] 
	  
	  tags = {
	    Name = "sahana-vm-tf"
	  }
	  
	  provisioner "file" {
	    source      = "../deployment/docker-compose.yaml"
	    destination = "docker-compose.yaml"
	       
	       connection {
	              user        = "ubuntu"
	              type        = "ssh"
	              private_key = "${file(var.pvt_key)}"
	              host        = "${aws_instance.backend.public_ip}"
	       }
	  }
	  
	  provisioner "remote-exec" {
	    
	    inline = [
	      "sudo apt-get update",
	      "sudo apt-get install python sshpass -y",
	    ]
	    connection {
	              user        = "ubuntu"
	              type        = "ssh"
	              private_key = "${file(var.pvt_key)}"
	              host        = "${aws_instance.backend.public_ip}"
	       }
	  }
	}  
	
	resource "null_resource" "ansible-main" {
	    provisioner "local-exec" {
	      command = <<EOT
	            sleep 100;
	            > jenkins-ci.ini;
	            echo "[jenkins-ci]"| tee -a jenkins-ci.ini;
	            export ANSIBLE_HOST_KEY_CHECKING=False;
	            echo "${aws_instance.backend.public_ip}" | tee -a jenkins-ci.ini;
	            ansible-playbook -e  sshKey=${var.pvt_key} -i jenkins-ci.ini ./ansible/setup-backend.yaml -u ubuntu -v
	        EOT
	    }
	}

