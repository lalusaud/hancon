namespace :admin do
  desc "Create or update an admin login (requires ADMIN_EMAIL and ADMIN_PASSWORD)"
  task create: :environment do
    email = ENV.fetch("ADMIN_EMAIL") { abort "Set ADMIN_EMAIL to the admin's email address." }
    password = ENV.fetch("ADMIN_PASSWORD") { abort "Set ADMIN_PASSWORD to a strong password." }
    abort "ADMIN_PASSWORD must be at least 12 characters." if password.length < 12

    user = User.find_or_initialize_by(email_address: email)
    user.password = password
    user.password_confirmation = password
    user.save!
    puts "Admin login ready for #{user.email_address}. Sign in at /session/new, then open /admin."
  end
end
