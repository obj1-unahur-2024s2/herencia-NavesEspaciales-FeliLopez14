class Nave{
    var velocidad
    var direccionRespectoAlSol
    var combustible

    method acelerar(cantidad) {velocidad = 100000.min(velocidad + cantidad)}
    method desacelerar(cantidad) {velocidad = 0.max(velocidad - cantidad)}
    method irHaciaElSol() {
        if(direccionRespectoAlSol != 10){
            direccionRespectoAlSol = 10
        }
    }
    method escaparDelSol() {
        if(direccionRespectoAlSol != -10){
            direccionRespectoAlSol = -10
        }
    }
    method ponerseParaleloAlSol() {
        if(direccionRespectoAlSol != 0){
            direccionRespectoAlSol = 0
        }
    }
    method acercarseUnPocoAlSol() {
        direccionRespectoAlSol = 10.min(direccionRespectoAlSol + 1)
    }
    method alejarseUnPocoDelSol() {
        direccionRespectoAlSol = -10.max(direccionRespectoAlSol - 1)
    }
    method cargarCombustible(cantidad) {combustible += cantidad}
    method descargarCombustible(cantidad) {combustible = 0.max(combustible - cantidad)}
    method prepararViaje() {
        self.cargarCombustible(30000)
        self.acelerar(5000)
    }
    method estaTranquila() = combustible >= 4000 && velocidad < 12000
    method escapar() {}
    method avisar() {}
    method recibirAmenaza() {
        self.escapar()
        self.avisar()
    }
    method estaDeRelajo() = self.estaTranquila()
}


class NaveBaliza inherits Nave{
    var colorBaliza 
    var cambiosDeColor = 0

    method colorBaliza() = colorBaliza
    method cambiarColorDeBaliza(color) {colorBaliza = color}
    override method prepararViaje() {
        colorBaliza = "verde"
        cambiosDeColor += 1
        self.ponerseParaleloAlSol()
    }
    override method estaTranquila() = super() && colorBaliza != "rojo"
    override method escapar() {self.irHaciaElSol()}
    override method avisar() {
        self.cambiarColorDeBaliza("rojo")
        cambiosDeColor += 1
    }
    override method estaDeRelajo() = super() && self.tienePocaActividad()
    method tienePocaActividad() = cambiosDeColor == 0
}


class NaveDePasajeros inherits Nave{
    const property cantidadPasajeros
    var racionesDeComida
    var racionesDeBebida
    var racionesDeComidaServidas = 0

    method cargarRacionesDeComida(cantidad){racionesDeComida += cantidad}
    method cargarRacionesDeBebida(cantidad){racionesDeBebida += cantidad}
    method descargarRacionesDeComida(cantidad){racionesDeComida -= cantidad}
    method descargarRacionesDeBebida(cantidad){racionesDeBebida -= cantidad}

    override method prepararViaje() {
        self.cargarRacionesDeBebida(6 * cantidadPasajeros)
        self.cargarRacionesDeComida(4 * cantidadPasajeros)
        self.acercarseUnPocoAlSol()
    }
    override method escapar() {velocidad = velocidad * 2}
    override method avisar() {
        self.descargarRacionesDeBebida(2 * cantidadPasajeros)
        self.descargarRacionesDeComida(cantidadPasajeros)
        racionesDeComidaServidas += cantidadPasajeros
    }
    override method estaDeRelajo() = super() && self.tienePocaActividad()
    method tienePocaActividad() = racionesDeComidaServidas < 50
}


class NaveDeCombate inherits Nave{
    var visibilidad
    var misilesDesplegados
    const property mensajes = []

    method estaInvisible() = visibilidad
    method ponerseInvisible() {visibilidad = false}
    method ponerseVisible() {visibilidad = true}

    method desplegarMisiles() {misilesDesplegados = true}
    method replegarMisiles() {misilesDesplegados = false}
    method misilesDesplegados() = misilesDesplegados

    method emitirMensaje(unMensaje) {mensajes.add(unMensaje)}
    method mensajesEmitidos() = mensajes.size()
    method primerMensajeEmitido() = mensajes.first()
    method ultimoMensajeEmitido() = mensajes.last()
    method esEscueta() = mensajes.all({m => !m.size() > 30})
    method emitioMensaje(unMensaje) = mensajes.contains(unMensaje)

    override method prepararViaje() {
        self.ponerseVisible()
        self.replegarMisiles()
        self.acelerar(15000)
        self.emitirMensaje("Saliendo en mision")
    }
    override method estaTranquila() = super() && !misilesDesplegados
    override method escapar() {
        self.acercarseUnPocoAlSol()
        self.acercarseUnPocoAlSol()
    }
    override method avisar() {self.emitirMensaje("Amenaza recibida")}
}


class NaveHospital inherits NaveDePasajeros{
    var property quirofanosPreparados

    override method estaTranquila() = super() && !quirofanosPreparados
    override method recibirAmenaza() {
        self.escapar()
        self.avisar()
        quirofanosPreparados = true
    }
}


class NaveSigilosa inherits NaveDeCombate{
    override method estaTranquila() = super() && visibilidad
    override method recibirAmenaza() {
        self.escapar()
        self.avisar()
        self.desplegarMisiles()
        self.ponerseInvisible()
    }
}