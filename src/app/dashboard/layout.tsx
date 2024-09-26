import Navbar from "../ui/Navbar"
import Sidebar from "../ui/Sidebar"


export default function DashboardLayout({
    children, // will be a page or nested layout
}: {
    children: React.ReactNode
}) {
    return (
        <div style={{ display: 'flex' }}>
        <Sidebar />
        <div style={{ flexGrow: 1 }}>
          <Navbar />
          <div style={{ padding: '20px' }}>
            {children}
          </div>
        </div>
      </div>
    )
}