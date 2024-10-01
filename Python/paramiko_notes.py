
import paramiko
import paramiko.client

def context_ssh_client_cmd_wrapper(cmd: str=None, host: str=None, username: str=None) -> None:
        with paramiko.client.SSHClient() as client:
            client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            client.connect(hostname=host, username=username)
            _stdin, _stdout, _stderr = client.exec_command(cmd)
            print(f"Response:\n\tTarget Host {host}\n\tCommand: {cmd}\nstdout:\n{_stdout.read().decode()}")

            if _stderr:
                print(f"stderr: {_stderr.read().decode()}")

        return
