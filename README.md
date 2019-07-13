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
cd ..
zip runtime.zip cbmbasic bootstrap
aws s3 cp runtime.zip s3://[your-bucket]
```
## Performance

Performance of the basic interpreter is actually pretty good, given it's rather small footprint the startup time is neglible compared to even Python:

```sh
[nicolai@bastion lambda-c64-basic-runtime]$ time python2 handler.py 1> /dev/null

real    0m0.012s
user    0m0.010s
sys     0m0.000s
[nicolai@bastion lambda-c64-basic-runtime]$ time python3 handler.py 1> /dev/null

real    0m0.015s
user    0m0.009s
sys     0m0.004s
[nicolai@bastion lambda-c64-basic-runtime]$ time ./cbmbasic handler.bas 1> /dev/null

real    0m0.001s
user    0m0.001s
sys     0m0.000s
```
However, running as Lambda runtime things change a bit. Python is a builtin runtime for Lambda, supported by AWS. while we bootstrap our runtime with a bash script, sure to delay things a bit:

TO BE COMPLETED
