import AccountSidebar from "@/components/account-sidebar"
import ProfileDetails from "@/components/profile-details"

export default function AccountPage() {
  return (
    <div className="flex min-h-screen bg-gray-50">
      {/* Account Sidebar */}
      <AccountSidebar />

      {/* Main Content */}
      <div className="flex-1 p-8">
        <ProfileDetails />
      </div>
    </div>
  )
}
