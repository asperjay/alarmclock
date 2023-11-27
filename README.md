ssh -i Downloads/KeyPair.pem ec2-user@**insert server ip**\
  go to https://signin.aws.amazon.com/signin?redirect_uri=https%3A%2F%2Fconsole.aws.amazon.com%2Fconsole%2Fhome%3FhashArgs%3D%2523%26isauthcode%3Dtrue%26state%3DhashArgsFromTB_us-east-2_028b8a201cbf55a8&client_id=arn%3Aaws%3Asignin%3A%3A%3Aconsole%2Fcanvas&forceMobileApp=0&code_challenge=trMkx9b8xTIsAkdzKbWv8jUTXNi3HghWMNJ6AEiqqFM&code_challenge_method=SHA-256\
  to find it

ps -ef | grep python

nohup python3 server.py
