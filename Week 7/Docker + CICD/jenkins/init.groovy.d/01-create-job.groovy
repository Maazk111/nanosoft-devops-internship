import jenkins.model.*
import hudson.security.*
import java.util.logging.Logger

def logger = Logger.getLogger("week7-init")

def instance = Jenkins.get()

// Enable security and create admin/admin if not already configured
if (instance.getSecurityRealm() instanceof hudson.security.SecurityRealm.None) {
  logger.info("Configuring Jenkins security realm and admin user...")

  def hudsonRealm = new HudsonPrivateSecurityRealm(false)
  hudsonRealm.createAccount("admin", "admin")
  instance.setSecurityRealm(hudsonRealm)

  def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
  strategy.setAllowAnonymousRead(false)
  instance.setAuthorizationStrategy(strategy)

  instance.save()
  logger.info("Admin user created: admin/admin")
} else {
  logger.info("Security realm already configured.")
}