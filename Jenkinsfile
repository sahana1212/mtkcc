node {
    jdk = tool name: 'jenkins-jdk'
    env.JAVA_HOME = "${jdk}"
    
    
	stage('GITHUB CHECKOUT') {    
	   git 'https://github.com/sahana1212/mtkcc.git'
	}
	
	stage('DOWNLOADING ARTIFACTS') {          
		server = Artifactory.server 'artifactory'
		
		downloadSpec = """{
			"files": [{
				"pattern": "sahana-artifactory/*.war",
				"target": "web/"
			}]
		}"""          
		
		server.download(downloadSpec)
	}
		
	stage('DOCKER-COMPOSE COMMAND') {
		sh label: 'Docker', script: 'docker-compose up -d --build'
	}
	
	stage('PUSH IMG TO DOCKERHUB'){
         sh label: '', script: 'docker login -u sahana1212 -p sahana1212'
         //sh label: '', script: 'docker tag mtkcc sahana1212/mtkcc'
         sh label: '', script: 'docker push sahana1212/cricket-app'
         
         //GETTING ERROR HERE
    }
    
    stage('TERRAFORM [IaaC]'){
        
        tf_path = "terraform/"
		
		dir(tf_path) {    
			sh label: 'terraform', script: '/bin/terraform  init'
			sh label: 'terraform', script: '/bin/terraform  plan --out tfplan.out'
			
		}
        
    }
    
    stage ('PROVISIONING RESOURCES [TF + Ansible]'){
        dir(tf_path) {    
			sh label: 'terraform', script: '/bin/terraform apply tfplan.out'
		}
    }
    
    stage ('CLEAN-UP'){
        dir(tf_path) {    
			sh label: 'terraform', script: '/bin/terraform destroy -input=false -auto-approve'
		}
    }
    
    
}
