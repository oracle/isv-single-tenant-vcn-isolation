file "/tmp/helloworld.txt" do
  owner "opc"
  group "opc"
  mode 0777
  action :create
  content "Hello, Implementor!!!"
end

file "/tmp/helloworld.out" do
  owner "opc"
  group "opc"
  mode 0777
  action :create
  content "Hello, Sunil Bemarkar!!!"
end