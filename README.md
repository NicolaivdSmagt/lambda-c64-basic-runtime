# lambda-c64-basic-runtime
A [custom runtime](https://aws.amazon.com/about-aws/whats-new/2018/11/aws-lambda-now-supports-custom-runtimes-and-layers/)
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

Next, we'll combine the runtime and the interpreter in a zipfile, and upload to S3. 
```sh
zip runtime.zip cbmbasic bootstrap
aws s3 cp runtime.zip s3://[your-bicket]
```

TO BE COMPLETED
