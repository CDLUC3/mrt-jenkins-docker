import java.util.logging.Logger
import jenkins.model.Jenkins
import hudson.model.*

Logger.global.info("Running startup.groovy...")

Jenkins.instance.save() // TODO: what does this do?

def job = Jenkins.instance.getJob('seed')
Jenkins.instance.queue.schedule(job, 0, new CauseAction(new Cause() {
  @Override
  String getShortDescription() {
    'Running startup.groovy'
  }
}))

Logger.global.info("...startup.groovy complete.")

