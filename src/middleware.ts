import { NextRequest, NextResponse } from 'next/server';

export function middleware(request: NextRequest) {
  // Example: i18n redirect based on Accept-Language header
  // (Extend this for real i18n or auth logic)
  // const lang = request.headers.get('accept-language')?.split(',')[0] || 'en';
  // if (!request.nextUrl.pathname.startsWith(`/${lang}`)) {
  //   return NextResponse.redirect(new URL(`/${lang}${request.nextUrl.pathname}`, request.url));
  // }
  return NextResponse.next();
}

export const config = {
  matcher: [
    // Apply to all routes
    '/((?!_next|api|static|favicon.ico).*)',
  ],
};
