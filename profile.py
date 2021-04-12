#!/usr/bin/env python

#
# Standard geni-lib/portal libraries
#
import geni.portal as portal
import geni.rspec.pg as rspec
import geni.rspec.emulab as elab
import geni.rspec.igext as IG

#
# Globals
#
class GLOBALS(object):
    SITE_URN = "urn:publicid:IDN+emulab.net+authority+cm"
    # Use kernel version required by free5gc: Ubuntu 18, kernel 5.0.0-23-generic
    UBUNTU18_IMG = "urn:publicid:IDN+emulab.net+image+reu2020:ubuntu1864std50023generic"
    # default type
    HWTYPE = "d430"
    SCRIPT_DIR = "/local/repository/scripts/"


def invoke_script_str(filename):
    # redirection all output to /script_output
    return "sudo bash " + GLOBALS.SCRIPT_DIR + filename + " &> ~/5g_install_script_output"

#
# This geni-lib script is designed to run in the PhantomNet Portal.
#
pc = portal.Context()

#
# Create our in-memory model of the RSpec -- the resources we're going
# to request in our experiment, and their configuration.
#
request = pc.makeRequestRSpec()

# Optional physical type for all nodes.
pc.defineParameter("phystype",  "Optional physical node type",
                   portal.ParameterType.STRING, "",
                   longDescription="Specify a physical node type (d430,d740,pc3000,d710,etc) " +
                   "instead of letting the resource mapper choose for you.")

# Retrieve the values the user specifies during instantiation.
params = pc.bindParameters()
pc.verifyParameters()



# Create the link between the `sim-gnb` and `5GC` nodes.
gNBCoreLink = request.Link("gNBCoreLink")

# Add node which will run gNodeB and UE components with a simulated RAN.
sim_ran = request.RawPC("sim-ran")
sim_ran.component_manager_id = GLOBALS.SITE_URN
sim_ran.disk_image = GLOBALS.UBUNTU18_IMG
#sim_ran.docker_extimage = "ubuntu:20.04"
sim_ran.hardware_type = params.phystype 
sim_ran.addService(rspec.Execute(shell="bash", command=invoke_script_str("ran.sh")))
gNBCoreLink.addNode(sim_ran)

# Add node that will host the 5G Core Virtual Network Functions (AMF, SMF, UPF, etc).
open5gs = request.RawPC("open5gs")
open5gs.component_manager_id = GLOBALS.SITE_URN
open5gs.disk_image = GLOBALS.UBUNTU18_IMG
#open5gs.docker_extimage = "ubuntu:20.04"
open5gs.hardware_type = GLOBALS.HWTYPE if params.phystype != "" else params.phystype
open5gs.addService(rspec.Execute(shell="bash", command=invoke_script_str("open5gs.sh")))
gNBCoreLink.addNode(open5gs)

pc.printRequestRSpec(request)
