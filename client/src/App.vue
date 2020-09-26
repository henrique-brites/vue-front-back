<template>
  <div>
    <div class="row">
      <div class="items col-md-7">
      <input type="text" class="form-control" v-model="filter" placeholder="O que você está buscando?"/>
      <br/>
        <div class="list-group">
          <div class="list-group-item" v-for="item in filteredItems" v-bind:key="item.id">
            <div class="row">
              <div class="col-md-2">
                <span class="badge badge-info"> {{ item.category }}</span>
              </div>
              <div class="col-md-6">
                <h5>{{ item.description }}</h5>
              </div>
              <div class="col-md-2">
              <h5>{{ formatMoney(item.price) }}</h5>
              </div>
              <div class="col-md-2 text-right">
                <button class="btn btn-outline-info btn-sm" v-on:click="addItem(item)"> 
                  <span class="fa fa-plus"></span>
                </button>
                &nbsp;
                <button class="btn btn-outline-info btn-sm" v-on:click="deleteItem(item)">
                  <span class="fa fa-minus"></span>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="order col-md-5">
        <div class="row">
          <div class="col-md">
            <h4>Pedido #{{ order.id }}</h4>
          </div>
          <div class="col-md text-right">
            <h4>{{ formatMoney(order.total) }} </h4>
          </div>
        </div>
        <hr/>
        <div v-for="orderItem in order.orderItems" v-bind:key="orderItem.item.id">
          <div class="row">
            <div class="col-md-2">
              {{ orderItem.quntity }}
            </div>
            <div class="col-md-7">
              {{ orderItem.item.description }}
            </div>
            <div class="col-md-3 text-right">
              {{ formatMoney(orderItem.quntity * orderItem.item.price) }}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import 'bootstrap/dist/css/bootstrap.css';
import 'font-awesome/css/font-awesome.css';

export default {
  name: 'App',
  data() {
    return {
      items: [],
      filter: "",
      order: {
        id: Math.floor(Math.random() * 10000),
        orderItems: [],
        total: 0
      }
    }
  },
  methods: {
    formatMoney(value) {
      const formatter = new Intl.NumberFormat('pt-BR', {
        style: 'currency',
        currency: 'BRL'
      });
      return formatter.format(value);
    },
    addItem(item) {
      const existingItem = this.order.orderItems.find(orderItems => orderItems.item.id === item.id);
      if (!existingItem) {
        this.order.orderItems.push({ quntity: 1, item });
      } else {
        existingItem.quntity++;
      }
      this.order.total += item.price;
    },
    deleteItem(item) {
      const existingItem = this.order.orderItems.find(orderItems => orderItems.item.id === item.id);
      if (existingItem) {
        existingItem.quntity--;
        this.order.total -= item.price;
        if (existingItem.quntity === 0) {
          this.order.orderItems.splice(this.order.orderItems.indexOf(existingItem), 1);
        }
      }
    }
  },
  computed: {
    filteredItems() {
      if (!this.filter) return this.items;
      return this.items.filter(item => item.description.toLowerCase().includes(this.filter.toLowerCase()));
    }
  },
  created() {
    this.items.push({ id: 1, category: 'Bebida', description: 'Água', price: 5 });
    this.items.push({ id: 2, category: 'Bebida', description: 'Suco', price: 10 });
    this.items.push({ id: 3, category: 'Bebida', description: 'Refrigerante', price: 12 });
  }
};
</script>
  
<style>
.items {
      padding: 30px;
  }
.order {
      padding: 30px;
      background-color: #F1F1F1;
      height: 100vh;
  }
</style>