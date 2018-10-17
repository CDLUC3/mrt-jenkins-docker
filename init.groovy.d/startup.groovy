import hudson.model.Cause.RemoteCause
import hudson.model.CauseAction
import hudson.model.Queue
import jenkins.model.Jenkins

import java.util.logging.Logger

Logger.global.info("Running startup.groovy...")

def jenkins = Jenkins.get()
def job = (Queue.Task) jenkins.getItem('seed')
def action = new CauseAction(new RemoteCause("localhost", "Running startup.groovy"))
jenkins.queue.schedule(job, 0, action)

Logger.global.info("...startup.groovy complete.")
