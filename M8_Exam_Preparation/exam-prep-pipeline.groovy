pipeline 
{
    agent 
    {
        label 'docker-node'
    }
    
    stages 
    {
        stage('Clone') 
        {
            steps 
            {
                git branch: 'main', url: 'http://192.168.150.102:3000/examadmin/exam'
            }
        }
        
        stage('Build')
        {
            steps
            {
                sh 'cd consumer && docker image build -t consumer-img .'
                sh 'cd producer && docker image build -t producer-img .'
                sh 'cd storage && docker image build -t storage-img .'
            }
        }
        
        stage('Run')
        {
            steps
            {
                sh 'docker network ls | grep app-net || docker network create app-net'

                sh 'docker container rm -f dob-storage || true'
                sh "docker container run -d --name dob-storage --net app-net -e MYSQL_ROOT_PASSWORD='Exam-2021' storage-img"

                sh 'docker container rm -f dob-producer || true'
                sh 'docker container run -d --name dob-producer --net app-net producer-img'

                sh 'docker container rm -f dob-consumer || true'
                sh 'docker container run -d --name dob-consumer --net app-net -p 8080:5000 consumer-img'
            }
        }

        stage('Clean') 
        {
            steps
            { 
                cleanWs()
            }
        }
    }

}
