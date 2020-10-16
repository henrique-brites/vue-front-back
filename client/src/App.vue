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
        <hr/>
        <div class="form-group">
          <input type="text" class="form-control" v-model="item.category" placeholder="Categoria"/>
        </div>
        <div class="form-group">
          <input type="text" class="form-control" v-model="item.description" placeholder="Descrição"/>
        </div>
        <div class="form-group">
          <input type="text" class="form-control" v-model.number="item.price" placeholder="Preço"/>
        </div>
        <button class="btn btn-outline-info btn-block" @click="saveItem(item)">Adicionar</button>

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
import axios from 'axios/dist/axios';

export default {
  name: 'App',
  data() {
    return {
      items: [],
      item: {},
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
    },
    saveItem(item) {
      axios({
        url: 'http://localhost:4000',
        method: 'post',
        data: {
          query: `
            mutation ($item: ItemInput) {
              newItem: saveItem (item: $item) {
                id
                category
                description
                price
              }
            }
          `  ,
          variables: {
            item
          }
        }
      }).then(response => {
        const body = response.data;
        const query = body.data;
        this.items.push(query.newItem);
        this.item = {};
      })
    }
  },
  computed: {
    filteredItems() {
      if (!this.filter) return this.items;
      return this.items.filter(item => item.description.toLowerCase().includes(this.filter.toLowerCase()));
    }
  },
  created() {
    axios({
      url: 'http://localhost:4000',
      method: 'post',
      data: {
        query: `
          {
            items {
              id
              category
              description
              price
            }
          }
        `  
      }
    }).then(response => {
      const body = response.data;
      const query = body.data;
      this.items = query.items;
    });
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