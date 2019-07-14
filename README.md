# Custom Commodore 64 Basic V2 runtime for AWS Lambda
![C64](http://nicolai-public.s3.amazonaws.com/c64.jpg)<br>
I used to have fun manually copying Commodore Basic listings from magazines into my machine for hours on end, only to find out I didn't like the resulting game that much.
It's been a while since I created my last piece of C64 Basic code, but I still figured it made sense to have a Commodore 64 Basic V2 interpreter in AWS Lambda for those people looking to port their C64 code to serverless microservices. So, here is a [custom runtime](https://aws.amazon.com/about-aws/whats-new/2018/11/aws-lambda-now-supports-custom-runtimes-and-layers/)
for AWS Lambda to execute functions in Commodore 64 Basic V2. 

## Building the binary

We're going to need a Commodore 64 Basic interpreter. [Here](https://github.com/mist64/cbmbasic) is a recompiled version of the original Commodore binary. This is preferred over other interpreters that rely on emulation. Run a [Lambda execution environment](https://docs.aws.amazon.com/lambda/latest/dg/current-supported-versions.html) and compile cbmbasic.

```sh
git clone https://github.com/NicolaivdSmagt/lambda-c64-basic-runtime.git
cd lambda-c64-basic-runtime
git clone https://github.com/mist64/cbmbasic
cd cbmbasic
make
mv cbmbasic ..
```
## Creating Lambda layer
Next, we'll combine the runtime and the interpreter in a zipfile, and create the Lambda layer from it.
```sh
cd ..
zip runtime.zip cbmbasic bootstrap
aws lambda publish-layer-version --layer-name c64-runtime --zip-file fileb://runtime.zip
```
## Creating the handler function
The handler function should also be zipped to create the Lambda function from it. Use an existing IAM role for your function or create a new one, and provide the ARN of the layer created in the previous step. The included example can be fronted by an ALB to provide a fully serverless, dynamic webpage in C64 basic..
```sh
zip handler.zip handler.bas
aws lambda create-function --function-name c64-web-template --zip-file fileb://handler.zip --handler handler.bas --runtime provided --role arn:aws:iam::123456789012:role/your-role-ARN-here --layers arn:aws:lambda:eu-west-1:123456789012:layer:c64-runtime:1
```
Resulting in this:

![Success](https://nicolai-public.s3-eu-west-1.amazonaws.com/images/2BC6D4E6-B61A-4E8A-9C2E-B76B07FED283.png)
## Performance

Performance of the basic interpreter is actually pretty good, given it's rather small footprint the startup time is neglible compared to even Python:

```sh
[nicolai@bastion lambda-c64-basic-runtime]$ time python2 perf-test.py 1> /dev/null

real    0m0.012s
user    0m0.010s
sys     0m0.000s
[nicolai@bastion lambda-c64-basic-runtime]$ time python3 perf-test.py 1> /dev/null

real    0m0.015s
user    0m0.009s
sys     0m0.004s
[nicolai@bastion lambda-c64-basic-runtime]$ time ./cbmbasic handler.bas 1> /dev/null

real    0m0.001s
user    0m0.001s
sys     0m0.000s
```
However, running as Lambda runtime things change a bit. Python is a builtin runtime for Lambda, supported by AWS. Since our runtime is bootstrapped from a bash script, we add some additional startup latency. A warmed-up C64 Basic Lambda function completes in about 300ms, while a warmed-up Python function runs in as little as 1ms.
