
import { getServerSession } from "next-auth";
import { redirect } from "next/navigation";
import { PrismaClient } from "@prisma/client";
import GalleryClient from "./GalleryClient";

const prisma = new PrismaClient();

export default async function GalleryPage() {
  const session = await getServerSession();
  if (!session) redirect("/login");
  const userRole = session.user?.role;
  const userId = session.user?.id;

  // Fetch media with uploader and comments
  const media = await prisma.galleryMedia.findMany({
    where: { hidden: false, deleted: false },
    orderBy: { createdAt: "desc" },
    include: {
      uploader: { select: { id: true, name: true, email: true } },
      comments: {
        include: { user: { select: { id: true, name: true, email: true } } },
        orderBy: { createdAt: "asc" },
      },
    },
  });

  // Fetch notifications for uploader
  let notifications: any[] = [];
  if (userId) {
    notifications = await prisma.notification.findMany({
      where: { userId, read: false },
      orderBy: { createdAt: "desc" },
    });
  }

  return (
    <GalleryClient
      media={media}
      notifications={notifications}
      userRole={userRole}
      userId={userId}
    />
  );
}
