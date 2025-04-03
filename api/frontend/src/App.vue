<template>
  <div class="container">
    <h1 class="title">BUSCA DE OPERADORAS</h1>
    <input
      v-model ="termoBusca"
      @input="buscarOperadoras"
      placeholder="Digite o nome da operadora..."
      class="search-input"
    >

    <div v-if="carregando" class="loading">Carregando...</div>

    <div v-else>
      <div v-for="operadora in operadoras" :key="operadora.CNPJ" class="company-card">
        <h2 class="company-name">{{ operadora.Nome_Fantasia }}</h2>
        <div class="company-details">
          <p><span class="detail-label">CNPJ:</span> {{ operadora.CNPJ }} </p>
          <p><span class="detail-label">Razão Social:</span> {{ operadora.Razao_Social }}</p>
          <p><span class="detail-label">Telefone:</span> ({{ operadora.DDD }}) {{ operadora.Telefone }}</p>      
        </div>
      </div>

      <p v-if="operadoras.length === 0 && termoBusca.length >= 3" class="no-results">
      Nenhum resultado encontrado para "{{ termoBusca }}"
      </p>
    </div>
  </div>
</template>


<style scoped>
  .container {
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
    font-family: Arial, sans-serif;
  }
  .title {
    color: #72b3f3;
    text-align: center;
    margin-bottom: 20px;
  }
  .search-input {
    width: 100%;
    padding: 12px;
    font-size: 16px;
    border: 1px solid #ddd;
    border-radius: 4px;
    margin-bottom: 20px;
    box-sizing: border-box;
  }
  .loading {
    text-align: center;
    padding: 20px;
    color: #666
  }
  .company-card {
    background-color: #ffffff;
    background-color: #ffffff;
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    padding: 20px;
    margin-bottom: 15px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    transition: transform 0.2s;
  }
  .company-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
  }
  .company-name {
    color: #3498db;
    margin-top: 0;
    margin-bottom: 10px;
  }
  .company-details {
    color: #555;
  }
  .detail-label {
    font-weight: bold;
    color: #2c3e50;
  }
  .no-results {
    text-align: center;
    color: #7f8c8d;
    font-style: italic;
    padding: 20px;
  }
</style>













<script>
export default {
  data() {
    return {
      termoBusca: '',
      operadoras: [],
      carregando: false
    }
  },
  methods: {
    async buscarOperadoras() {
      if (this.termoBusca.length < 3) {
        this.operadoras = [];
        return;
      }
      
      this.carregando = true;
      try {
        const response = await fetch(`http://localhost:8000/buscar?termo=${encodeURIComponent(this.termoBusca)}`);
        this.operadoras = await response.json();
      } catch (error) {
        console.error("Erro na busca:", error);
        this.operadoras = [];
      } finally {
        this.carregando = false;
      }
    }
  }
}
</script>