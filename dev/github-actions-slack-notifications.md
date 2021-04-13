# Slack notifications for GitHub Actions

Max Horn, Chris Jefferson, Sergio Siccha, and Wilf Wilson have access to the
app `GAP GH Actions Notifications`. If you have access, then you can access the
app via

    https://api.slack.com/apps
    -> Your Apps

The only feature that is needed is the `Incoming Webhooks`. On the `Incoming
Webhooks` page, the webhook URLs can be managed at the bottom of the page. The
webhook URLs must be stored in the gap-system/gap repository as a secret. It
can then be used in an action via

    - name: Send message to slack workspace
      uses: act10ns/slack@e4e71685b9b239384b0f676a63c32367f59c2522
      with: 
        status: ${{ job.status }}
      env:
        SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}

