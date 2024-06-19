resource "local_file" "hosts_ini" {
    filename = "./inventory/hosts.ini"
    content = <<EOF
[nfs_server]
${aws_instance.NFS.public_ip}
[nfs_clients]
${aws_instance.NFS-Client.public_ip}
EOF

depends_on = [ aws_instance.NFS, aws_instance.NFS-Client ]

}

resource "local_file" "ansible_cfg" {
  filename = "ansible.cfg"
  content =  <<EOF
[defaults]
inventory = ${local_file.hosts_ini.filename}
remote_user = ec2-user
host_key_checking = False
retry_files_enabled = False
command_warnings = False
roles_path = ./roles
private_key_file= ~/.ssh/nfs_key

[privilege_escalation]
become = True
become_method = sudo
become_user = root
become_ask_pass = False
  EOF

}

resource "local_file" "group-vars-nfs-ips" {
  filename = "group_vars/all.yml"
  content = <<EOF
nfs_server: ${aws_instance.NFS.private_ip}
EOF
}

resource "local_file" "private_ip_txt" {
    filename = "private_ip.txt"
    content = <<EOF
{
    "NFS": "${aws_instance.NFS.private_ip}",
    "NFS-Client": "${aws_instance.NFS-Client.private_ip}"
}
EOF
}