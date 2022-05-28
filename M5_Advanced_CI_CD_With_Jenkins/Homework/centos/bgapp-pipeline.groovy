pipeline 
{
    agent 
    {
        label 'docker-node'
    }
    
    environment 
    {
        DOCKERHUB_CREDENTIALS=credentials('docker-hub')
    }
    
    stages 
    {
        stage('Clone') 
        {
            steps 
            {
                git branch: 'main', url: 'http://192.168.111.202:3000/examadmin/exam'
            }
        }
        
        stage('Build')
        {
            steps
            {
                sh 'cd storage && docker image build -t storage-img .'
                sh 'cd generator && docker image build -t generator-img .'
                sh 'cd client && docker image build -t client-img .'
            }
        }
        
        stage('Run')
        {
            steps
            {
                sh 'docker network ls | grep app-net || docker network create app-net'

                sh 'docker container rm -f con-storage || true'
                sh  "docker container run -d --name con-storage --net app-net -e MYSQL_ROOT_PASSWORD='ExamPa\$\$w0rd' storage-img"

                sh 'docker container rm -f con-generator || true'
                sh 'docker container run -d --name con-generator --net app-net generator-img'

                sh 'docker container rm -f con-client || true'
                sh 'docker container run -d --name con-client --net app-net -p 8080:5000 client-img'
            }
        }
        
        stage('CleanUp') 
        {
            steps 
            {
                sh 'docker container rm -f con-storage con-generator con-client'
            }
        }
        
        stage('Login')
        {
            steps 
            {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        
        stage('Push')
        {
            steps 
            {
                sh 'docker image tag storage-img vladimirr11/storage-img'
                sh 'docker push vladimirr11/storage-img'
                
                sh 'docker image tag generator-img  vladimirr11/generator-img'
                sh 'docker push vladimirr11/generator-img'
                
                sh 'docker image tag client-img  vladimirr11/client-img'
                sh 'docker push vladimirr11/client-img'
            }
        }
        
        stage('Deploy')
        {
            steps
            {
                sh 'docker network ls | grep app-net || docker network create app-net'

                sh 'docker container rm -f con-storage || true'
                sh  "docker container run -d --name con-storage --net app-net -e MYSQL_ROOT_PASSWORD='ExamPa\$\$w0rd' storage-img"

                sh 'docker container rm -f con-generator || true'
                sh 'docker container run -d --name con-generator --net app-net generator-img'

                sh 'docker container rm -f con-client || true'
                sh 'docker container run -d --name con-client --net app-net -p 80:5000 client-img'
            }
        }
    }

    post 
    { 
        always 
        { 
            cleanWs()
        }
    }

}
