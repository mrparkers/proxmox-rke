jenkins:
  authorizationStrategy:
    loggedInUsersCanDoAnything:
      allowAnonymousRead: true
  securityRealm:
    local:
      allowsSignup: false
      enableCaptcha: false
      users:
        - id: "$${chart-admin-username}"
          name: "Jenkins Admin"
          password: "$${chart-admin-password}"
  disableRememberMe: false
  remotingSecurity:
    enabled: true
  mode: NORMAL
  numExecutors: 0
  labelString: ""
  projectNamingStrategy: "standard"
  markupFormatter:
    plainText
  clouds:
    - kubernetes:
        containerCapStr: "10"
        defaultsProviderTemplate: ""
        connectTimeout: "5"
        readTimeout: "15"
        jenkinsUrl: "http://jenkins.jenkins.svc.cluster.local:8080"
        jenkinsTunnel: "jenkins-agent.jenkins.svc.cluster.local:50000"
        maxRequestsPerHostStr: "32"
        name: "kubernetes"
        namespace: "jenkins"
        serverUrl: "https://kubernetes.default"
        podLabels:
          - key: "jenkins/jenkins-jenkins-agent"
            value: "true"
        templates:
          - name: "default"
            id: eeb122dab57104444f5bf23ca29f3550fbc187b9d7a51036ea513e2a99fecf0f
            containers:
              - name: "jnlp"
                alwaysPullImage: false
                args: "^$${computer.jnlpmac} ^$${computer.name}"
                command:
                envVars:
                  - envVar:
                      key: "JENKINS_URL"
                      value: "http://jenkins.jenkins.svc.cluster.local:8080/"
                image: "jenkins/inbound-agent:4.11-1"
                privileged: "false"
                resourceLimitCpu: 512m
                resourceLimitMemory: 512Mi
                resourceRequestCpu: 512m
                resourceRequestMemory: 512Mi
                runAsUser:
                runAsGroup:
                ttyEnabled: false
                workingDir: /home/jenkins/agent
            idleMinutes: 0
            instanceCap: 2147483647
            label: "jenkins-jenkins-agent "
            nodeUsageMode: "NORMAL"
            podRetention: Never
            showRawYaml: true
            serviceAccount: "default"
            slaveConnectTimeoutStr: "100"
            yamlMergeStrategy: override
          - name: "minimal"
            label: "minimal"
            nodeUsageMode: NORMAL
            containers:
              - name: "agent"
                image: "alpine"
                alwaysPullImage: false
                workingDir: "/home/jenkins/agent"
                command: "/bin/sh -c"
                args: "cat"
                ttyEnabled: true
                resourceRequestCpu: 50m
                resourceLimitCpu: 500m
                resourceRequestMemory: 64Mi
                resourceLimitMemory: 128Mi
            volumes:
              - hostPathVolume:
                  hostPath: "/var/run/docker.sock"
                  mountPath: "/var/run/docker.sock"
            slaveConnectTimeout: 100
            serviceAccount: "jenkins"
  crumbIssuer:
    standard:
      excludeClientIPFromCrumb: true
security:
  apiToken:
    creationOfLegacyTokenEnabled: false
    tokenGenerationOnCreationEnabled: false
    usageStatisticsEnabled: true
unclassified:
  location:
    url: https://jenkins.parker.gg
