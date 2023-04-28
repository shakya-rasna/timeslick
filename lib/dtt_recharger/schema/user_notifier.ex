defmodule DttRecharger.Schema.UserNotifier do
  import Swoosh.Email

  alias DttRecharger.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"DttRecharger", "noreply@dttrecharger.com"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, "Confirmation instructions", """

    ==============================

    Hi #{user.email},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions for invitation account.
  """
  def deliver_invitations(user, organization, password) do
    deliver(user.email, "Invitation to DTT Recharger", """

    ==============================

    Hi #{user.first_name} #{user.last_name},

    Welcome to DTT Recharger! Use below credentials for login :

    email: #{user.email}
    password: #{password}
    organization: #{organization.name}

    ==============================
    """)
  end

  def deliver_invitations(user, organization) do
    deliver(user.email, "Invitation to DTT Recharger", """

    ==============================

    Hi #{user.first_name} #{user.last_name},

    Welcome to DTT Recharger! you have been invited to organization #{organization.name}, use your login creds to login :

    email: #{user.email}
    organization: #{organization.name}

    ==============================
    """)
  end

  def deliver_admin_invitations(user, password) do
    deliver(user.email, "Invitation to DTT Recharger", """

    ==============================

    Hi #{user.first_name} #{user.last_name},

    Welcome to DTT Recharger! You have been invited as admin on DTT Recharger. Use below credentials for login :

    email: #{user.email}
    password: #{password}

    ==============================
    """)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    deliver(user.email, "Reset password instructions", """

    ==============================

    Hi #{user.email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "Update email instructions", """

    ==============================

    Hi #{user.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end
end
