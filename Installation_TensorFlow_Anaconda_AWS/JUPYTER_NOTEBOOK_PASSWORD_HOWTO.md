# Setting up a password protected Jupyter Notebook server on an AWS instance

This guide will show you have to setup a password protect Jupyter Notebook server on an AWS instance

1- ssh into your AWS instance

2- Open ipython into the terminal (simpliy type ipython)

3- Type the following lines to passward protect Jupyter Notebook Server when launch

```
In [1]: from IPython.lib import passwd

In [2]: passwd()
```

4- When you successfully entered a password, be sure to save the sha1 hash output

5- Type exit() to exit ipython

6- In the terminal, type the following lines:

```
jupyter notebook --generate-config 
mkdir certs
cd certs
sudo openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mycert.pem -out mycert.pem
cd ~/.jupyter/
```

7- With your favourite editor, open the file 'jupyter_notebook_config.py' 

8- At the beginning to the file, type the following statements:

```
c= get_config()

# Kernal config
c.IPKernelApp.pylab = 'inline' # if you want plotting support always

# Notebook config
c.NotebookApp.certfile = u'/home/ubuntu/certs/mycert.pem'
c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False

# Sha1 hash password
c.NotebookApp.password = u'sha1:PASSWORD_HOLDER'
c.NotebookApp.port = 8888
```

9- Save the file

10- Created a folder to launch the password protected server using the command line: nohup jupyter notebook

11- In a broswer, enter the following URL:

```
https://Public_IP:8888/
```