from django.core.management.base import NoArgsCommand
from django.utils import timezone
from django.template.loader import render_to_string
from django.conf import settings
from django.core.mail import EmailMultiAlternatives
from datetime import timedelta
from main.models import Event
from django.contrib.sites.models import Site

def send_html_mail(subject, plaintext, html, from_address, recipients):
    msg = EmailMultiAlternatives(subject, plaintext, from_address, recipients)
    msg.attach_alternative(html, 'text/html')
    msg.send()

class Command(NoArgsCommand):
    help = "Queues reminder emails for two days before event"

    def handle_noargs(self, **options):
        self.email_tasks()

    def email_tasks(self):
        set = Event.objects.filter(date_start__gte=timezone.now() + timedelta(days=2),
                                   date_start__lt=timezone.now() + timedelta(days=3))
        site = Site.objects.get_current()
        for i in set:
            plaintext = render_to_string('email/event_remind.txt', {'site': site, 'event': i})
            html = render_to_string('email/event_remind.html', {'site': site, 'event': i})
            recipients = list(map(lambda x: x.email, i.participants.filter(user_profile__email_valid=True)))
            send_html_mail('[AtYourService] Event reminder for {}'.format(i.name),
                           plaintext,
                           html,
                           settings.DEFAULT_FROM_EMAIL,
                           recipients)
