import java.util.logging.Logger
import jenkins.model.Jenkins
import hudson.model.*

Logger.global.info("Running startup.groovy...")

Jenkins.instance.save() // TODO: what does this do?

Jenkins.instance.queue.schedule(
  Jenkins.instance.getJob('seed'),
  0,
  new RemoteCause("localhost", "Running startup.groovy")
)
Logger.global.info("...startup.groovy complete.")
