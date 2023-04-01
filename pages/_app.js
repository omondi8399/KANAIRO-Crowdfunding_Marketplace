import '@/styles/globals.css'

//INTERNAL IMPORT
import { NavBar, Footer } from '../Components'

export default function App({ Component, pageProps }) {
  return (
    <>
     <NavBar />
    <Component {...pageProps} />
    <Footer />
    </>
  ) 
}
