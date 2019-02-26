To run memory test

1. plug in the usb/jtag cable 
2. plug in the usb/uart cable

In Windows Device Manager, found the correspondent COM port

3. Install Python 3 on Windows

4. Compile and Download the project

5. To run memory test, open a command prompt, goto scripts folder, and type in 

python reindeer_config.py --port=COMxx --mem_test_len=0x1000 

