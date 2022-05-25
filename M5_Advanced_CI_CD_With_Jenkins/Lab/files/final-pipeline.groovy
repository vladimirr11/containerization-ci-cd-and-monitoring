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
                git branch: 'main', url: 'http://192.168.99.102:3000/<username>/supercalc'
            }
        }
        
        stage('Build')
        {
            steps
            {
                sh 'docker image build -t img-calc .'

            }
        }
        stage('Run')
        {
            steps
            {
                sh 'docker container rm -f co-calc || true'
                sh 'docker container run -d -p 8080:80 --name co-calc img-calc'
            }
        }
        stage('Test')
        {
            steps
            {
                script 
                {
                    echo 'Test #1 - reachability'
                    sh 'echo $(curl --write-out "%{http_code}" --silent --output /dev/null http://localhost:8080) | grep 200'

                    echo 'Test #2 - 40 + 2 = 42'
                    sh "curl --silent --data 'opa=40&opr=add&opb=2' http://localhost:8080 | grep 42"
                    
                    echo 'Test #3 - 150 - 108 = 42'
                    sh "curl --silent --data 'opa=150&opr=sub&opb=108' http://localhost:8080 | grep 42"
                }
            }
        }
        stage('CleanUp')
        {
            steps
            {
                sh 'docker container rm -f co-calc || true'
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
                sh 'docker image tag img-calc <username>/supercalc'
                sh 'docker push <username>/supercalc'
            }
        }
        stage('Deploy')
        {
            steps
            {
                sh 'docker container rm -f calcapp || true'
                sh 'docker container run -d -p 80:80 --name calcapp <username>/supercalc'
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
