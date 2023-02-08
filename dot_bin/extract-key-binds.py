import os
import sys
import getopt

def usage():
    print("python3 extract-key-bindings.py [(-c|--config=) <configFile>] [(-o|--output) <outputFile>]")
    print("\t <configFile>: path to config file where key binds should be extracted. Default: .config/hypr/hyprland.conf")
    print("\t <outputFile>: path to output file, old file will be cleared. Default: .config/helper/keybind.txt")

def openConf(config):
    return open(config)

def extract(f):
    binds = []
    vars = []
    for line in f:
        if line.startswith("$"):
            vars.append(line.strip("\n").split(" = "))
        elif line.startswith("bind = "):
            binds.append(line.strip("bind = "))
    f.close()
    return binds, vars


def replaceVars(binds, vars):
    bindList = "".join(binds)
    for var in vars:
        bindList = bindList.replace(var[0], var[1])
    return bindList

def writeToFile(binds, output):
    if os.path.exists(output):
        os.remove(output)
    f = open(output, "x")
    f.write(binds)
    f.close()

def readOpts():
    try:
        opts, args = getopt.getopt(sys.argv[1:], 'c:o:', ['config=', 'output=']) 
    except getopt.GetoptError:
        usage()
        sys.exit(2)
    config = os.path.expanduser(os.path.join("~", ".config", "hypr", "hyprland.conf"))
    # output = os.path.expanduser(os.path.join("~", ".config", "hypr", "keybinds.txt"))
    output = os.path.join(os.path.expanduser(os.path.join("~", ".config", "helper")), "keybinds.txt")
    for opt, arg in opts:
        if opt in ("-c", "--config"):
            config = arg
        elif opt in ("-o", "--output"):
            output = arg
    return config, output

if __name__ == "__main__":
    config, output = readOpts()
    print(config)
    print(output)
    file = openConf(config)
    binds, vars = extract(file)
    bindList = replaceVars(binds, vars)
    writeToFile(bindList, output)
